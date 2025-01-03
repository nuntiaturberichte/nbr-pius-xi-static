# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/nuntiaturberichte/nbr-pius-xi-data/archive/refs/heads/main.zip
unzip main

mv ./nbr-pius-xi-data-main/data/ .

rm main.zip
rm -rf ./nbr-pius-xi-data-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh
