#!/bin/bash

echo "make calendar data"
python make_calendar_data.py

python oai-pmh/make_files.py

echo "create app"
ant