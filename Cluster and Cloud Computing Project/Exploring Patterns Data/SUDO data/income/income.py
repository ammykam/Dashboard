import pandas as pd
import json
import math

# Read the CSV file
df = pd.read_csv("income.csv", header=0)
df = df.sort_values('year').drop_duplicates('sa2_main11',keep='last')

df = df[['sa2_main11','sa2_name11','Average total income']]
df = df[(df['sa2_main11'] > 199999999)]
df = df[(df['sa2_main11'] < 300000000)]


def processData(data):
    place = data.split('(')[0].split('-')[0].strip().lower()
    return place

df['sa2_name11'] = df['sa2_name11'].apply(lambda x: processData(x))
df = df[['sa2_name11','Average total income']]

ssa_code = open('../vic_sal/geo_vic_filter_lga.geojson')
ssa_code_json = json.load(ssa_code)
ssa_code_json = ssa_code_json['features']

salary_geojson = {'type':'FeatureCollection','features':[]}

for index, data in df.iterrows():
    name = data['sa2_name11']

    matchData = next((item for item in ssa_code_json for s in item["properties"]['ssa_name'] if name in s),None)

    if(matchData != None):

        resultFeature = [data for data in salary_geojson['features'] for sub in data['properties']['ssa_name'] if name in sub]

        if(len(resultFeature) != 0):
            resultFeature[0]['properties']['income'] += data['Average total income']
        else:
            resultFeature = {'type':'Feature','geometry':matchData['geometry'],'properties': matchData['properties']}
            resultFeature['properties']['income'] = data['Average total income']
            salary_geojson['features'].append(resultFeature)

salary_geojson

with open('salary_geojson.geojson', 'w') as fp:
    json.dump(salary_geojson, fp)
    
