#!/bin/bash

# download links
curl https://openpolicing.stanford.edu/data/ | grep -Eoi '<a [^>]+>' | grep -Eoi 'https:.*\.csv.gz' > data-links.txt

# download data
cat data-links.txt | xargs -n 1 curl -LO
mkdir data
mv *.csv.gz ./data/
gzip -d ./data/*

# download county data
curl -o ./data/county-pop.csv https://www2.census.gov/programs-surveys/popest/datasets/2010-2015/counties/asrh/cc-est2015-alldata.csv
