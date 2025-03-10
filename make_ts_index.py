import glob
import os
import typesense

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext, normalize_string
from tqdm import tqdm

# Typesense Konfiguration für lokale Ausführung
TYPESENSE_API_KEY = "xyz"
TYPESENSE_HOST = "localhost"
TYPESENSE_PORT = "8108"

client = typesense.Client({
    "nodes": [{
        "host": TYPESENSE_HOST,
        "port": TYPESENSE_PORT,
        "protocol": "http",
    }],
    "api_key": TYPESENSE_API_KEY,
    "connection_timeout_seconds": 10
})

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
    "enable_nested_fields": True,
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
            "sort": True,
        },
        {
            "name": "receiver",
            "type": "string[]",
            "optional": True,
            "facet": True,
            "sort": True,
        },
    ],
}

# Neue Collection erstellen
client.collections.create(current_schema)

# Daten aus TEI-XML-Dateien einlesen
#files = glob.glob("./data/editions/**/*.xml", recursive=True)
files = glob.glob("../nbr-pius-xi-data/editions/**/*.xml", recursive=True)
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
    cfts_record["resolver"] = f"https://nuntiaturberichte.github.io/nbr-graz-static/{record['id']}.html"
    record["rec_id"] = record["id"]
    cfts_record["rec_id"] = record["rec_id"]

    # Jahr extrahieren
    try:
        year = doc.any_xpath(".//tei:correspAction[@type='sent']/tei:date[@when]")[0].attrib.get("when", "")
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
    cfts_record = {"project": COLLECTION_NAME, "persons": []}
    record["author"] = [
        normalize_string(y.text) for y in doc.any_xpath(".//tei:titleStmt/tei:author/tei:persName") if y.text
    ]
    if not record["author"]:
        record["author"] = None
    cfts_record["persons"] = record["author"] if record["author"] else []

    # Empfänger extrahieren
    record["receiver"] = [
        normalize_string(y.text) for y in doc.any_xpath(".//tei:correspAction[@type='received']//tei:persName") if
        y.text
    ]
    if not record["receiver"]:
        record["receiver"] = None
    cfts_record["persons"] = record["receiver"] if record["receiver"] else []

    # Volltext extrahieren
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]

    records.append(record)
    cfts_records.append(cfts_record)

# Dokumente in Typesense speichern
make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"✅ Fertig mit Indexierung {COLLECTION_NAME}")

# Überprüfen, ob die Collection existiert, bevor `CFTS_COLLECTION` verwendet wird
existing_collections = [col['name'] for col in client.collections.retrieve()]
if COLLECTION_NAME in existing_collections:
    CFTS_COLLECTION = client.collections[COLLECTION_NAME]
else:
    print(f"⚠️  Collection '{COLLECTION_NAME}' existiert nicht.")
    CFTS_COLLECTION = None  # Verhindert Fehler durch falschen Zugriff

# CFTS-Indexierung durchführen
if CFTS_COLLECTION:
    make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
    print(make_index)
    print(f"✅ Fertig mit CFTS-Indexierung {COLLECTION_NAME}")
else:
    print("⚠️  CFTS_COLLECTION ist nicht korrekt konfiguriert.")