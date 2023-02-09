import pandas as pd
# to run in terminal: python3 source/cleaning/state_unemployment/state_unemployment.py

def label_state(row):
    if row['STATE'] == 'Alabama': return 1
    if row['STATE'] == 'Arizona': return 2
    if row['STATE'] == 'Arkansas': return 3
    if row['STATE'] == 'California': return 4
    if row['STATE'] == 'Colorado': return 5
    if row['STATE'] == 'Connecticut': return 6
    if row['STATE'] == 'Delaware': return 7
    if row['STATE'] == 'District of Columbia': return 8
    if row['STATE'] == 'Florida': return 9
    if row['STATE'] == 'Georgia': return 10
    if row['STATE'] == 'Idaho': return 11
    if row['STATE'] == 'Illinois': return 12
    if row['STATE'] == 'Indiana': return 13
    if row['STATE'] == 'Iowa': return 14
    if row['STATE'] == 'Kansas': return 15
    if row['STATE'] == 'Kentucky': return 16
    if row['STATE'] == 'Louisiana': return 17
    if row['STATE'] == 'Maine': return 18
    if row['STATE'] == 'Maryland': return 19
    if row['STATE'] == 'Massachusetts': return 20
    if row['STATE'] == 'Michigan': return 21
    if row['STATE'] == 'Minnesota': return 22
    if row['STATE'] == 'Mississippi': return 23
    if row['STATE'] == 'Missouri': return 24
    if row['STATE'] == 'Montana': return 25
    if row['STATE'] == 'Nebraska': return 26
    if row['STATE'] == 'Nevada': return 27
    if row['STATE'] == 'New Hampshire': return 28
    if row['STATE'] == 'New Jersey': return 29
    if row['STATE'] == 'New Mexico': return 30
    if row['STATE'] == 'New York': return 31
    if row['STATE'] == 'North Carolina': return 32
    if row['STATE'] == 'North Dakota': return 33
    if row['STATE'] == 'Ohio': return 34
    if row['STATE'] == 'Oklahoma': return 35
    if row['STATE'] == 'Oregon': return 36
    if row['STATE'] == 'Pennsylvania': return 37
    if row['STATE'] == 'Rhode Island': return 38
    if row['STATE'] == 'South Carolina': return 39
    if row['STATE'] == 'South Dakota': return 40
    if row['STATE'] == 'Tennessee': return 41
    if row['STATE'] == 'Texas': return 42
    if row['STATE'] == 'Utah': return 43
    if row['STATE'] == 'Vermont': return 44
    if row['STATE'] == 'Virginia': return 45
    if row['STATE'] == 'Washington': return 46
    if row['STATE'] == 'West Virginia': return 47
    if row['STATE'] == 'Wisconsin': return 48
    if row['STATE'] == 'Wyoming': return 49
    if row['STATE'] == 'Alaska': return 50
    if row['STATE'] == 'Hawaii': return 51
    else: return "Error, missing state check data."

# Read in data as df
unemployment_df = pd.read_excel('data/state_unemployment/state_year_unemployment_raw.xls')

# Unpivot
unemployment_df = pd.wide_to_long(unemployment_df, stubnames=["unemploy"], i="Area", j="year", sep="_")

# Turn multi-index into columns
unemployment_df = unemployment_df.reset_index(level=0)
unemployment_df = unemployment_df.reset_index(level=0)

# Relabel column names
unemployment_df = unemployment_df.rename({'year': 'year', 'Area': 'STATE', 'unemploy':'unemployment'}, axis=1)

# Relabel states
unemployment_df['state'] = unemployment_df.apply(lambda row: label_state(row), axis=1)

# Remove United States obs
unemployment_df = unemployment_df.drop(unemployment_df[unemployment_df.STATE == 'United States'].index)

# Drop state names
unemployment_df = unemployment_df.drop('STATE', axis=1)

# Covert to numeric
unemployment_df['year'] = unemployment_df['year'].astype(int)
unemployment_df['state'] = unemployment_df['state'].astype(int)

# Export to csv
unemployment_df.to_csv('data/state_unemployment/state_year_unemployment_clean.csv', index=False)
