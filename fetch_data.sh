#!/bin/bash

echo "Fetching transcriptions from data_repo"

# Lösche und erstelle neue Verzeichnisse für die Daten
rm -rf data/ && mkdir data

# Lade das Repository als ZIP-Archiv herunter
echo "Downloading repo as zip-file"
curl -LO https://codeload.github.com/nuntiaturberichte/nbr-pius-xi-data/zip/refs/heads/default
ls -l

# Entpacke das heruntergeladene ZIP-Archiv
echo "unzipping zip-file"
unzip default
ls -l

# # Verschiebe die benötigten Ordner aus dem tieferen Verzeichnis in die entsprechenden Verzeichnisse unter "data"
echo "moving content from unpacked zip folder to ./data"
mv ./nbr-pius-xi-data-default/* ./data


# # Bereinige: Lösche das heruntergeladene ZIP-Archiv und das entpackte Verzeichnis
echo "removing zip-file and its unpacked content"
rm default
rm -rf ./nbr-pius-xi-data-default

echo "Transcriptions have been successfully updated."

echo "fetching imprint"
./shellscripts/dl_imprint.sh