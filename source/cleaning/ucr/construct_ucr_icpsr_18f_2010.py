import pandas as pd
import time
from helpers_ucr_icpsr import *


def main():
    # Load data files into ucr_dfs list as dataframes
    ucr_dfs, ucr_years = [], []
    start_year, last_year = 2000, 2016 
    cols_to_readin = ['STATE', 'OFFENSE', 'YEAR', 'POP', 'AB']
    for year in range(start_year, last_year + 1):
        ucr_years.append(year)
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_stata('data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.dta', columns=cols_to_readin, preserve_dtypes=False))
    
    # Clean each df
    cleaned_avg_dfs, cleaned_sum_dfs = [], []
    for ucr_df in ucr_dfs:
        ucr_df.apply(pd.to_numeric, errors='ignore')
        ucr_df['state_num'] = ucr_df.apply(lambda row: label_state(row), axis=1)
        # Delete 'STATE' column and replace with 'state_num'
        ucr_df = ucr_df.drop('STATE', axis=1)
        ucr_df = ucr_df.rename({'state_num': 'STATE'}, axis=1)
        ucr_df['AB'] = pd.factorize(ucr_df['AB'])[0]  # convert categorical variable to numeric

        grouped_sum_df = groupby_state2010(drop_rows(ucr_df))
        grouped_avg_df = groupby_state_avg2010(drop_rows(ucr_df))
        cleaned_avg_dfs.append(grouped_avg_df)
        cleaned_sum_dfs.append(grouped_sum_df)
    
    # Concatenate into one df
    output_sum, output_avg = concatenate_dfs(cleaned_sum_dfs), concatenate_dfs(cleaned_avg_dfs)

    # Export final dfs to csvs
    output_sum.to_csv('data/UCR_ICPSR/clean/ucr_sum_2010.csv', index=False)
    output_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_2010.csv', index=False)


if __name__ == "__main__":
    start_time = time.time()
    main()
    print("-------" + str(time.time() - start_time) + " seconds ------")
