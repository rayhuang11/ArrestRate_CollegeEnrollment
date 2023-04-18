import pandas as pd
import plotly.express as px

def main():
    df = pd.read_csv('data/UCR_ICPSR/clean/ucr_avg_ab_alloffenses_1986.csv')
    df = construct_state_abrev_col(clean(df))
    plot(df)

def clean(df):
    df["year"] = pd.to_numeric(df["year"])
    offense_to_drop = ["180", "185", "18A", "18B", "18C", "18D", "18E", "18F", "18G", "18H"]
    for offense in offense_to_drop:
        df = df.drop(df[df.OFFENSE == offense ].index)
    for offense in range(180, 190):
        df = df.drop(df[df.OFFENSE == str(offense) ].index)
    df = df.drop(df[df.year != 1984].index)
    df["ab"] = pd.to_numeric(df["ab"])
    return df

def plot(df):
    fig = px.choropleth(df,
                    locations='state_abbreviation', 
                    locationmode="USA-states", 
                    scope="usa",
                    color='ab',
                    color_continuous_scale="orrd", 
                    hover_name='state_abbreviation',
                    range_color=[0, 30],
                    labels={'ab': 'Arrest rate'}
                    )
    fig.show()
    #fig.write_image("/Users/rayhuang/Documents/Thesis-git/output/figures/heatmap/ab_heatmap.png")
    # image is v low quality, download it from browser

def construct_state_abrev_col(df):
    state_code_to_abbreviation = {
    1: 'AL', 2: 'AZ', 3: 'AR', 4: 'CA', 5: 'CO', 6: 'CT', 7: 'DE', 8: 'DC', 9: 'FL', 10: 'GA', 11: 'ID', 12: 'IL', 13: 'IN',
    14: 'IA', 15: 'KS', 16: 'KY', 17: 'LA',
    18: 'ME', 19: 'MD', 20: 'MA', 21: 'MI', 22: 'MN', 23: 'MS', 24: 'MO', 25: 'MT', 26: 'NE', 27: 'NV', 28: 'NH', 29: 'NJ',
    30: 'NM', 31: 'NY', 32: 'NC', 33: 'ND', 34: 'OH', 35: 'OK', 36: 'OR', 37: 'PA', 38: 'RI', 39: 'SC', 40: 'SD', 41: 'TN', 
    42: 'TX', 43: 'UT', 45: 'VA', 44: 'VT', 47: 'WV', 46: 'WA',
    48: 'WI', 49: 'WY', 50: 'AK', 51: 'HI', 52: 'CZ', 53: 'PR', 54: 'AS', 55: 'GU', 62: 'VI'}
    df['state_abbreviation'] = df['STATE'].map(state_code_to_abbreviation)
    return df

if __name__ == "__main__":
    main()
