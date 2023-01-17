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
    cleaned_avg_dfs, cleaned_jb_avg_dfs = [], []
    for ucr_df in ucr_dfs:
        cleaned_avg_dfs.append(groupby_state_avg_alloffenses(drop_rows_alloffenses(ucr_df))) # drop unneeded rows, groupby, append to lst of clean dfs
        cleaned_jb_avg_dfs.append(groupby_state_avg_alloffenses(drop_rows_jb_alloffenses(ucr_df)))
    output_avg = concatenate_dfs(cleaned_avg_dfs)
    output_jb_avg = concatenate_dfs(cleaned_jb_avg_dfs)

    # Drop unnecessary columns to avoid errors down the road
    output_avg = drop_columns(output_avg, ['aw', 'jb', 'jw'])
    output_jb_avg = drop_columns(output_jb_avg, ['ab', 'aw', 'jw'])
    # Export final dfs to csvs
    output_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_ab_alloffenses_1986.csv', index=False)
    output_jb_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_jb_alloffenses_1986.csv', index=False)


if __name__ == "__main__":
    start_time = time.time()
    main()
    print("-------" + str(time.time() - start_time) + "seconds ------")
