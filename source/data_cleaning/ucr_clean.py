import pandas as pd

# Create list of filenames
ucr_years = []
for i in range(1980, 2015):
    file_name = 'ucr_' + str(i)
    ucr_years.append(file_name)

for ucr_year in ucr_years:
    arrests = pd.read_excel("../../Data/UCR/" + ucr_year + ".xls", engine='openpyxl')
