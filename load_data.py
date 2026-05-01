from os import path

from sqlalchemy import table

import pandas as pd
from connect_db import engine

files = {
    "dataset1": r"data\raw\Country-Series - Metadata.csv",
    "dataset2": r"data\raw\IDS_CountryMetaData.csv",
    "dataset3": r"data\raw\IDS_FootNoteMetaData.csv",
    "dataset4": r"data\raw\IDS_SeriesMetaData.csv",
    "dataset5": r"data\raw\IDS_ALLCountries_Data.csv" }


for table, path in files.items():
    df = pd.read_csv(path, encoding="latin1")  # FIXED encoding
    df.to_sql(table, engine, if_exists="replace", index=False)
    print(f"{table} loaded successfully")

    