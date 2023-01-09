import pandas as pd
import time

# Runtime: ~XY seconds
def main():
    # Load data files into ucr_dfs list as dataframes
    ucr_dfs, ucr_years, cleaned_dfs = [], [], []
    start_year, last_year = 2004, 2016  # can be adjusted
    cols_to_readin = ['STATE', 'OFFENSE', 'YEAR', 'POP', 'JW', 'JB', 'AW', 'AB']
    for year in range(start_year, last_year + 1):
        ucr_years.append(year)
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_stata('data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.dta', columns=cols_to_readin, preserve_dtypes=False))
    # Clean each df
    output_test = concatenate_dfs_vertically(ucr_dfs)
    output_test.to_csv('data/UCR_ICPSR/clean/icpsr_ucr_all_yrs_2010_TEST.csv', index=False)
    for ucr_df in ucr_dfs:
        ucr_df.apply(pd.to_numeric, errors='ignore')
        ucr_df = groupby_state(drop_rows(ucr_df))
        cleaned_dfs.append(ucr_df)
    output = concatenate_dfs_vertically(cleaned_dfs)
    # Export final df to csv
    output.to_csv('data/UCR_ICPSR/clean/icpsr_ucr_all_yrs_2010.csv', index=False)

def drop_rows(df):
    """ Drop rows not looking at possession of marijuana for a single df """
    # Note: different years use different offense codes (mainly 1981)
    return df.drop(df[(df.OFFENSE != '187') & (df.OFFENSE != '18F')].index)

def groupby_state(df):
    """ Group a dataframe by groupby_param """
    var_names = {'YEAR':'year', 'POP':'pop', 'JW':'jw', 'JB':'jb', 'AW':'aw', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'sum','JW':'sum', 'JB':'sum', 'AW':'sum', 'AB':'sum'}
    grouped_df = df.groupby('STATE', as_index=False).agg(agg_input).rename(columns=var_names)
    return grouped_df

def concatenate_dfs_vertically(dfs):
    """ Group all the dfs into one df """
    return pd.concat(dfs, ignore_index=True)

if __name__ == "__main__":
    start_time = time.time()
    main()
    print("--- %s seconds ---" % (time.time() - start_time))()
