import pandas as pd
import csv

AssetList_file = "../asset-files/AssetList.csv"

with open(AssetList_file) as csv_file:
    csv_reader = csv.reader(csv_file)
    line_count = 0
    
    for row in csv_reader:
        if line_count == 3:
            print(f"Column names are {row}")
            line_count += 1
        elif line_count == 1267:
            break
        else:
            print(f'\npostcode: {row[0].strip()}, localAuthority: {row[1].strip()}, businessArea: {row[2].strip()}.')
        line_count += 1

    print(f'Processed {line_count} lines.')
