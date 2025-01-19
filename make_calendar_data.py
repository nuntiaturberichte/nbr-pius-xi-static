import glob
import re
import os
import json
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

# Erstelle den Pfad für die Ausgabe
out_path = os.path.join("html", "js-data")
os.makedirs(out_path, exist_ok=True)

# Suche nach XML-Dateien
files = sorted(glob.glob("../nbr-pius-xi-data/TEI/editions/*.xml"))

# Definiere die Ausgabe-Datei
out_file = os.path.join(out_path, "calendarData.js")
data = []

# Verarbeite jede Datei
for x in tqdm(files, total=len(files)):
    item = {}
    head, tail = os.path.split(x)
    doc = TeiReader(x)

    # Extrahiere den Titel (Name des Ereignisses)
    name = doc.any_xpath('//tei:titleStmt/tei:title/text()')
    if name:
        cleaned_name = name[0].replace("\n", " ")
        item["name"] = re.sub(r"\s+", " ", cleaned_name)
    else:
        continue  # Wenn kein Titel vorhanden ist, überspringe die Datei

    # Versuche die Datumsangaben zu extrahieren
    correspActionSent_date = doc.any_xpath('//tei:correspAction[@type="sent"]/tei:date/@when')
    head_date = doc.any_xpath('//tei:head//tei:date/@when')
    opener_date = doc.any_xpath('//tei:opener//tei:date/@when')
    closer_date = doc.any_xpath('//tei:closer//tei:date/@when')
    creation_date = doc.any_xpath('//tei:creation//tei:date/@when')

    # Verarbeite @when-iso, @notBefore und @notAfter
    if correspActionSent_date:
        item["startDate"] = correspActionSent_date[0]
        item["endDate"] = correspActionSent_date[0]
    else:
        continue  # Wenn keine relevanten Datumsangaben vorhanden sind, überspringen

    # Bereinige Tageszähler und ID
    tageszaehler = doc.any_xpath('//tei:title[@type="iso-date"]/@n')
    if tageszaehler:
        item["tageszaehler"] = tageszaehler[0]
        item["id"] = tail.replace(".xml", ".html")
        data.append(item)
    else:
        continue  # Wenn kein Tageszähler vorhanden ist, überspringe die Datei

    # Setze die Farbe basierend auf den Bedingungen
    if when_iso and not cert:
        item["color"] = "#0d6efd"  # Wenn nur when_iso vorhanden ist, aber kein cert
    else:
        item["color"] = "#C74343"  # In allen anderen Fällen

# Ausgabe in die JS-Datei schreiben
print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)};"
    f.write(my_js_variable)
