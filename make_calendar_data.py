import glob
import re
import os
import json
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm
from collections import defaultdict

# Wörterbuch für den Zähler pro Datum
date_counter = defaultdict(int)

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
###
    # Extrahiere den Titel (Name des Ereignisses)
    name = doc.any_xpath('//tei:titleStmt/tei:title/text()')
    if name:
        cleaned_name = name[0].replace("\n", " ")
        item["name"] = re.sub(r"\s+", " ", cleaned_name)
    else:
        continue
###
    # Extrahiere das Datum
    date_xpaths = [
        '//tei:correspAction[@type="sent"]/tei:date/@when',  # 1. Priorität
        '//tei:creation//tei:date/@when'  # 2. Priorität
        '//tei:opener//tei:date/@when',  # 3. Priorität
        '//tei:closer//tei:date/@when',  # 4. Priorität
        '//tei:head//tei:date/@when',  # 5. Priorität
    ]

    for xpath in date_xpaths:
        date_value = doc.any_xpath(xpath)
        if date_value:
            item["startDate"] = date_value[0]
            item["endDate"] = date_value[0]
            break
    else:
        continue
###
    # Mapping der Farbe
    color_mapping = {
        "Brief": "#0d6efd",
        "Bericht": "#C74343",
        "Telegramm": "#6AB547",
        "Archivsnotiz": "#7B287D",
        "Provvista": "#f8c400"
    }

    document_type = doc.any_xpath('//tei:text/@type')
    if document_type:
        item["color"] = color_mapping.get(document_type[0], "#000000")
    else:
        item["color"] = "#000000"
###
    # Berechne den Tageszähler
    start_date = item["startDate"]
    date_counter[start_date] += 1
    item["tageszaehler"] = str(date_counter[start_date])
###
    # Erstelle die ID
    item["id"] = tail.replace(".xml", ".html")
    data.append(item)
###
# Ausgabe in die JS-Datei schreiben
print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)};"
    f.write(my_js_variable)
