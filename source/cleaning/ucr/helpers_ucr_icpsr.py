import pandas as pd

def drop_columns(df, columns: list):
    df = df.drop(columns, axis=1)
    return df

def drop_rows(df):
    """ Drop rows not looking at possession of marijuana for a single df """
    # Note: different years use different offense codes (mainly 1981)
    df = df.drop(df[(df.AB == 99998)| (df.AB == 99999) | (df.AB == 'None/not reported')].index)
    return df[(df.OFFENSE.str.contains("18"))]

def groupby_state(df):
    """ Group a dataframe by state, taking sum of arrests """
    var_names = {'YEAR':'year', 'POP':'pop', 'JW':'jw', 'JB':'jb', 'AW':'aw', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'sum','JW':'sum', 'JB':'sum', 'AW':'sum', 'AB':'sum'}
    grouped_df = df.groupby('STATE', as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

def groupby_state_avg(df):
    """ Group a dataframe by state, taking average of all vars """
    var_names = {'YEAR':'year', 'POP':'pop', 'JW':'jw', 'JB':'jb', 'AW':'aw', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'mean','JW':'mean', 'JB':'mean', 'AW':'mean', 'AB':'mean'}
    grouped_df = df.groupby('STATE', as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

def groupby_state2010(df):
    """ Group a dataframe by state, taking sum of arrests """
    var_names = {'YEAR':'year', 'POP':'pop', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'sum','AB':'sum'}
    grouped_df = df.groupby('STATE', as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

def groupby_state_avg2010(df):
    """ Group a dataframe by state, taking average of all vars """
    var_names = {'YEAR':'year', 'POP':'pop', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'sum','AB':'sum'}
    grouped_df = df.groupby('STATE', as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

def concatenate_dfs(dfs):
    """ Group all the dfs into one df """
    return pd.concat(dfs, ignore_index=True)

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
