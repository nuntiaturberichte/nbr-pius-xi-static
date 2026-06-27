import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client, CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext, normalize_string
from tqdm import tqdm


# Name der Collection
COLLECTION_NAME = "nbr-pius-xi"

# Falls die Collection existiert, löschen und neu erstellen
try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass

# Collection-Schema definieren
current_schema = {
    "name": COLLECTION_NAME,
    "enable_nested_fields": False,  # not needed because we don't index any objects
    "metadata": {
        "owners": ["Peter Andorfer", "Martin Kroißenbrunner"],
        "description": "https://github.com/nuntiaturberichte/nbr-pius-xi-static",
        "service_ids": [24835],
    },
    "fields": [
        {"name": "id", "type": "string", "sort": True},
        {"name": "rec_id", "type": "string", "sort": True},
        {"name": "title", "type": "string", "sort": True},
        {"name": "full_text", "type": "string", "sort": True},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
            "sort": True,
        },
        {
            "name": "author",
            "type": "string[]",
            "optional": True,
            "facet": True,
            "sort": False,
        },
        {
            "name": "receiver",
            "type": "string[]",
            "optional": True,
            "facet": True,
            "sort": False,
        },
    ],
}

# Neue Collection erstellen
client.collections.create(current_schema)

# Daten aus TEI-XML-Dateien einlesen
files = glob.glob("./data/editions/**/*.xml", recursive=True)
tag_blacklist = ["{http://www.tei-c.org/ns/1.0}abbr"]

records = []
cfts_records = []

for x in tqdm(files, total=len(files)):
    cfts_record = {"project": COLLECTION_NAME}
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        continue

    # ID und Resolver
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = (
        f"https://nuntiaturberichte.github.io/nbr-pius-xi-static/{record['id']}.html"
    )
    record["rec_id"] = record["id"]
    cfts_record["rec_id"] = record["rec_id"]

    # Jahr extrahieren
    try:
        year = doc.any_xpath(".//tei:correspAction[@type='sent']/tei:date[@when]")[
            0
        ].attrib.get("when", "")
        if len(year) >= 4 and year[:4].isdigit():
            record["year"] = int(year[:4])
        else:
            record["year"] = None
    except IndexError:
        record["year"] = None
    if record["year"] is None:
        print(f"⚠️  Kein gültiges Jahr gefunden für {record['id']}")

    # Titel extrahieren
    record["title"] = extract_fulltext(doc.any_xpath(".//tei:titleStmt/tei:title")[0])
    cfts_record["title"] = record["title"]

    # Autor extrahieren
    record["author"] = [
        normalize_string(y.text)
        for y in doc.any_xpath(".//tei:titleStmt/tei:author/tei:persName")
        if y.text
    ]
    if not record["author"]:
        record["author"] = None

    # Empfänger extrahieren
    record["receiver"] = [
        normalize_string(y.text)
        for y in doc.any_xpath(".//tei:correspAction[@type='received']//tei:persName")
        if y.text
    ]
    if not record["receiver"]:
        record["receiver"] = None

    # Combine authors and receivers for persons field
    persons = []
    if record["author"]:
        persons.extend(record["author"])
    if record["receiver"]:
        persons.extend(record["receiver"])
    cfts_record["persons"] = persons if persons else None

    # Volltext extrahieren
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]

    records.append(record)
    cfts_records.append(cfts_record)

# Dokumente in Typesense speichern
make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"✅ done with indexing {COLLECTION_NAME}")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print(f"done with cfts-index {COLLECTION_NAME}")
