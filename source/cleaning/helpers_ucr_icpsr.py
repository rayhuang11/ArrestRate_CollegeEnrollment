import pandas as pd


def drop_rows(df):
    """ Drop rows not looking at possession of marijuana for a single df """
    # Note: different years use different offense codes (mainly 1981)
    df = df.drop(df[(df.AB == 99999) | (df.AB == 'None/not reported')].index)
    return df.drop(df[(df.OFFENSE != '187') & (df.OFFENSE != '18F')].index)

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

def concatenate_dfs(dfs):
    """ Group all the dfs into one df """
    return pd.concat(dfs, ignore_index=True)
