import pandas as pd
import time
import helpers_ucr_icpsr

def main():
    # Load TSVs into ucr_dfs list as dataframes
    ucr_dfs = []
    ucr_years = [1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992]
    cols_to_readin = ['STATE', 'OFFENSE', 'YEAR', 'POP', 'JW', 'JB', 'AW', 'AB']
    for ucr_year in ucr_years:
        ucr_dfs.append(pd.read_csv('data/UCR_ICPSR/raw/icpsr_' + str(ucr_year) + '.tsv', sep='\t', usecols=cols_to_readin))
    
    # Clean each df
    cleaned_avg_dfs, cleaned_sum_dfs, cleaned_jb_avg_dfs = [], [], []
    for ucr_df in ucr_dfs:
        #grouped_sum_df = groupby_state(drop_rows(ucr_df))
        grouped_avg_df = groupby_state_avg(drop_rows(ucr_df))
        grouped_avg_jb_df = groupby_state_avg(drop_rows_jb(ucr_df))
        cleaned_avg_dfs.append(grouped_avg_df)
        cleaned_jb_avg_dfs.append(grouped_avg_jb_df)
        #cleaned_sum_dfs.append(grouped_sum_df)
    #output_sum = helpers_ucr_icpsr.concatenate_dfs(cleaned_sum_dfs), 
    output_avg = helpers_ucr_icpsr.concatenate_dfs(cleaned_avg_dfs)
    output_jb_avg = helpers_ucr_icpsr.concatenate_dfs(cleaned_jb_avg_dfs)

    # Drop unnecessary columns to avoid errors down the road
    output_avg = helpers_ucr_icpsr.drop_columns(output_avg, ['aw', 'jb', 'jw'])
    output_jb_avg = helpers_ucr_icpsr.drop_columns(output_jb_avg, ['ab', 'aw', 'jw'])

    # Export final dfs to csvs
    #output_sum.to_csv('data/UCR_ICPSR/clean/ucr_sum_alloffenses_1986.csv', index=False)
    output_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_ab_alloffenses_1986.csv', index=False)
    output_jb_avg.to_csv('data/UCR_ICPSR/clean/ucr_avg_jb_alloffenses_1986.csv', index=False)

def drop_rows(df):
    """ Drop rows not looking at possession of marijuana for a single df """
    # Note: different years use different offense codes (mainly 1981)
    df = df.drop(df[(df.AB == 99998)| (df.AB == 99999) | (df.AB == 'None/not reported')].index)
    return df[(df.OFFENSE.str.contains("18"))]

def drop_rows_jb(df):
    """ Drop rows not looking at possession of marijuana for a single df """
    # Note: different years use different offense codes (mainly 1981)
    df = df.drop(df[(df.JB == 99998)| (df.JB == 99999) | (df.JB == 'None/not reported')].index)
    return df[(df.OFFENSE.str.contains("18"))]

def groupby_state_avg(df):
    """ Group a dataframe by state, taking average of all vars """
    var_names = {'YEAR':'year', 'POP':'pop', 'JW':'jw', 'JB':'jb', 'AW':'aw', 'AB':'ab'}
    agg_input = {'YEAR':'mean', 'POP':'mean','JW':'mean', 'JB':'mean', 'AW':'mean', 'AB':'mean'}
    return df.groupby(['STATE', 'OFFENSE'], as_index=False).agg(agg_input).rename(columns=var_names)

if __name__ == "__main__":
    start_time = time.time()
    main()
    print("-------" + str(time.time() - start_time) + "seconds ------")
