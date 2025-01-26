#!/bin/bash

echo "Fetching transcriptions from data_repo"

# Lösche und erstelle neue Verzeichnisse für die Daten
rm -rf data/ && mkdir data

# Lade das Repository als ZIP-Archiv herunter
curl -LO https://codeload.github.com/nuntiaturberichte/nbr-pius-xi-data/zip/refs/heads/default

# Entpacke das heruntergeladene ZIP-Archiv
unzip default.zip

# # Verschiebe die benötigten Ordner aus dem tieferen Verzeichnis in die entsprechenden Verzeichnisse unter "data"
mv ./nbr-pius-xi-data-default/* ./data


# # Bereinige: Lösche das heruntergeladene ZIP-Archiv und das entpackte Verzeichnis
rm default.zip
rm -rf ./nbr-pius-xi-data-default

echo "Transcriptions have been successfully updated."

echo "fetching imprint"
./shellscripts/dl_imprint.sh