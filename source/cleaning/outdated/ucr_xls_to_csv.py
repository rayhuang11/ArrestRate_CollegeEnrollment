import pandas as pd


def main():
    convert_to_csv()


def gen_years(lb=1980, rb=2015):
    """ Helper function to generate list of years"""
    ucr_years = []
    for i in range(lb, rb):
        file_name = 'ucr_' + str(i)
        ucr_years.append(file_name)
    return ucr_years


def convert_to_csv():
    """ Convert all the fake xls files to csv, saving it all the .../data/UCR folder"""
    # Create list of file names
    ucr_years = gen_years()
    for ucr_year in ucr_years:
        arrests = pd.read_html("../../Data/UCR/" + ucr_year + ".xls")
        arrests = arrests[0]
        arrests.to_csv("../../Data/UCR/" + ucr_year + ".csv", index=None)


if __name__ == "__main__":
    main()
