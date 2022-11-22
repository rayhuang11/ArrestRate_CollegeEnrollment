import pandas as pd
import numpy as np
from matplotlib import pyplot as plt


def main():
    # Open csv files in a list as dataframes
    ucr_years = gen_ucr_years()
    ucr_all_years = []
    for ucr_year in ucr_years:
        ucr_all_years.append(pd.read_csv("../../Data/UCR/" + ucr_year + ".csv"))
    # Iterate through dataframes:
    white_adult_arrest_rates, white_juvenile_arrest_rates = [], []
    black_adult_arrest_rates, black_juvenile_arrest_rates = [], []
    for ucr_one_year in ucr_all_years:
        white_adult_arrest_rates.append(get_yaxis_data(ucr_one_year, age='adults', race='white'))
        white_juvenile_arrest_rates.append(get_yaxis_data(ucr_one_year, age='juvenile', race='white'))
        black_adult_arrest_rates.append(get_yaxis_data(ucr_one_year, age='adults', race='black'))
        black_juvenile_arrest_rates.append(get_yaxis_data(ucr_one_year, age='juvenile', race='black'))
    # Plot
    t1, t2, t3, t4 = 'White adults', 'White juveniles', 'Black adults', 'Black juveniles'
    outfile = '../../output/figures/britton_fig2'
    plot(white_adult_arrest_rates, white_juvenile_arrest_rates, black_adult_arrest_rates, black_juvenile_arrest_rates,
            t1, t2, t3, t4, title='Britton Fig2', outfile=outfile)


def gen_ucr_years(lb=1980, rb=2015):
    """ Helper function to generate list of ucr_years """
    ucr_years = []
    for i in range(lb, rb):
        file_name = 'ucr_' + str(i)
        ucr_years.append(file_name)
    return ucr_years


def clean_drop(arrest_datas:list):
    for arrest_data in arrest_datas:
        arrest_data = arrest_data.drop([36])


def get_yaxis_data(ucr_year, age, race, offense_index=21):
    """ Get the data for plotting from a single year """
    # Check age
    if age == 'all_ages':
        column_name = 'All Ages'
    elif age == 'adults':
        column_name = 'Ages 18 or over'
    elif age == 'juvenile':
        column_name = 'Ages under 18'
    # Check race
    if race == 'all':
        column_name += ''
    elif race == 'white':
        column_name += '.1'
    elif race == 'black':
        column_name += '.2'
    # Lookup and return value
    return float(ucr_year.loc[offense_index, column_name])


def plot(y1, y2, y3, y4, t1, t2, t3, t4, title, outfile, y_label='Possession', x_label='Year'):
    plt.figure(figsize=(10, 10))
    xaxis = np.linspace(1980, 2014, 35)
    # Overlay 4 plots
    plt.plot(xaxis, y1, linewidth=3, label=t1)
    plt.plot(xaxis, y2, linewidth=3, label=t2)
    plt.plot(xaxis, y3, linewidth=3, label=t3)
    plt.plot(xaxis, y4, linewidth=3, label=t4)
    plt.legend(loc="upper left")
    plt.title(title)
    plt.ylabel(y_label)
    plt.xlabel(x_label)
    plt.savefig(outfile, dpi=600)
    plt.figure().show()
    plt.close()


if __name__ == "__main__":
    main()