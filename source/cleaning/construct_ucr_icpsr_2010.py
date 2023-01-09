import pandas as pd
import time
from helpers_ucr_icpsr import *

def main():
    # Load data files into ucr_dfs list as dataframes
    ucr_dfs, ucr_years = [], []
    start_year, last_year = 2000, 2016  # can be adjusted
    cols_to_readin = ['STATE', 'OFFENSE', 'YEAR', 'POP', 'JW', 'JB', 'AW', 'AB']
    for year in range(start_year, last_year + 1):
        ucr_years.append(year)
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_stata('data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.dta', columns=cols_to_readin, preserve_dtypes=False))
    
    # Clean each df
    #output_test = concatenate_dfs(ucr_dfs)
    #output_test.to_csv('data/UCR_ICPSR/clean/icpsr_ucr_all_yrs_2010_TEST.csv', index=False)
    cleaned_avg_dfs, cleaned_sum_dfs = [], []
    for ucr_df in ucr_dfs:
        ucr_df.apply(pd.to_numeric, errors='ignore')
        grouped_sum_df = groupby_state(drop_rows(ucr_df))
        grouped_avg_df = groupby_state_avg(drop_rows(ucr_df))
        cleaned_avg_dfs.append(grouped_avg_df)
        cleaned_sum_dfs.append(grouped_sum_df)
    output_sum, output_avg = concatenate_dfs(cleaned_sum_dfs), concatenate_dfs(cleaned_avg_dfs)

    # Export final dfs to csvs
    output_sum.to_csv('data/UCR_ICPSR/clean/ucr_sum_2010.csv', index=False)
    output_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_2010.csv', index=False)

if __name__ == "__main__":
    start_time = time.time()
    main()
    print("-------" + str(time.time() - start_time) + "seconds ------")
