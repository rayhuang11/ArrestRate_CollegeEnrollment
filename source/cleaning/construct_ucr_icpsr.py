import pandas as pd
import time

# Runtime: ~110 seconds
def main():
    # Load TSVs into ucr_dfs list as dataframes
    ucr_dfs = []
    ucr_years = [1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992]
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_csv('../../data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.tsv', sep='\t'))
    # Clean each df
    cleaned_dfs = []
    for ucr_df in ucr_dfs:
        ucr_df = groupby_state(drop_rows(ucr_df))
        cleaned_dfs.append(ucr_df)
    output = concatenate_dfs_vertically(cleaned_dfs)
    # Export final df to csv
    output.to_csv('../../data/UCR_ICPSR/clean/icpsr_ucr_all_yrs.csv', index=False)

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
