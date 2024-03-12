import pandas as pd
import math
import json

# Read the CSV file
df = pd.read_csv("total_crime.csv", header=0)
df = df.replace(math.nan, 0)
df['total_crime'] = df.apply(lambda x: int(sum(x[4:])), axis = 1)
df = df[['lga_name11','lga_code','reference_period','total_crime']]

lga_code = open('../vic_sal/geo_vic_filter_lga.geojson')
lga_code_json = json.load(lga_code)

crime_geojson = {'type':'FeatureCollection','features':[]}

for data in lga_code_json['features']:
    code = int(data['properties']['code'])
    matchData = df[df['lga_code'] == code]

    resultFeature = {'type':'Feature','geometry':data['geometry'],'properties': data['properties']}
    for index, data in matchData.iterrows():
        resultFeature['properties']['total_crime'] = data['total_crime']
        resultFeature['properties']['year'] = data['reference_period']
    crime_geojson['features'].append(resultFeature)


with open('crime_geojson.geojson', 'w') as fp:
    json.dump(crime_geojson, fp)

df = pd.read_csv("domestic_violence.csv", header=0)
domesticVi_geojson = {'type':'FeatureCollection','features':[]}

for data in lga_code_json['features']:
    code = int(data['properties']['code'])
    matchData = df[df['lga_code11'] == code]

    resultFeature = {'type':'Feature','geometry':data['geometry'],'properties': data['properties']}
    for index, data in matchData.iterrows():
        resultFeature['properties']['violence_percentage'] = data['domestic_family_sexual_violence_rate_per_100k']
    domesticVi_geojson['features'].append(resultFeature)

with open('domesticVi_geojson.geojson', 'w') as fp:
    json.dump(domesticVi_geojson, fp)