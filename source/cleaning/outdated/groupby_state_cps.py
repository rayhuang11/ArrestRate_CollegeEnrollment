import pandas as pd

# Data is at the individual state-year level
cps_educ = pd.read_stata("../../data/CPS/cps_educ.dta")
print(cps_educ)

def groupby_state_year(df):
    """ Group a dataframe by groupby_param """
    var_names = {'YEAR':'year', 'POP':'pop', 'JW':'jw', 'JB':'jb', 'AW':'aw', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'sum','JW':'sum', 'JB':'sum', 'AW':'sum', 'AB':'sum'}
    grouped_df = df.groupby(['statefip', 'year'], as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

#cps_educ_grouped = groupby_state_year(cps_educ)
