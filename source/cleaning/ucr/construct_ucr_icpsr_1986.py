import pandas as pd
import time
from helpers_ucr_icpsr import *

def main():
    # Load TSVs into ucr_dfs list as dataframes
    ucr_dfs = []
    ucr_years = [1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992]
    cols_to_readin = ['STATE', 'OFFENSE', 'YEAR', 'POP', 'JW', 'JB', 'AW', 'AB']
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_csv('data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.tsv', sep='\t', usecols=cols_to_readin))
    
    # Clean each df
    cleaned_avg_dfs, cleaned_sum_dfs = [], []
    for ucr_df in ucr_dfs:
        grouped_sum_df = groupby_state(drop_rows(ucr_df))
        grouped_avg_df = groupby_state_avg(drop_rows(ucr_df))
        cleaned_avg_dfs.append(grouped_avg_df)
        cleaned_sum_dfs.append(grouped_sum_df)
    output_sum, output_avg = concatenate_dfs(cleaned_sum_dfs), concatenate_dfs(cleaned_avg_dfs)
    
    # Export final dfs to csvs
    output_sum.to_csv('data/UCR_ICPSR/clean/ucr_sum_1986.csv', index=False)
    output_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_1986.csv', index=False)

if __name__ == "__main__":
    start_time = time.time()
    main()
    print("-------" + str(time.time() - start_time) + "seconds ------")
