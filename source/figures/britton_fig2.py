import pandas as pd
import numpy as np
from matplotlib import pyplot as plt


def main():
    # Open csv files in a list
    ucr_years = gen_years()
    ucr_all_years = []
    for ucr_year in ucr_years:
        ucr_all_years.append(pd.read_csv("../../Data/UCR/" + ucr_year + ".csv"))


def gen_years(lb=1980, rb=2015):
    """ Helper function to generate list of years """
    ucr_years = []
    for i in range(lb, rb):
        file_name = 'ucr_' + str(i)
        ucr_years.append(file_name)
    return ucr_years


def clean_drop(arrest_datas:list):
    for arrest_data in arrest_datas:
        arrest_data = arrest_data.drop([36])


def plot():
    plt.figure(figsize=(10, 10))
    # Overlay 4 plots
    plt.plot(x_axis1, y_axis1, linewidth=3, label=type1)
    plt.plot(x_axis2, y_axis2, linewidth=3, label=type2)
    plt.plot(x_axis3, y_axis3, linewidth=3, label=type3)
    plt.plot(x_axis4, y_axis4, linewidth=3, label=type4)
    plt.legend(loc="upper left")
    plt.title(title)
    plt.ylabel(y_label)
    plt.xlabel(x_label)
    plt.savefig(outfile, dpi=600)
    plt.figure().show()
    plt.close()


if __name__ == "__main__":
    main()