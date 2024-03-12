import pandas as pd
import math
import json

# Read the CSV file
df = pd.read_csv("park.csv", header=0)

df['REC_SBCAT'].unique()

filter_values = ['PARKLANDS AND GARDENS','PARKS AND GARDENS']
df = df[df['REC_SBCAT'].isin(filter_values)]
df.to_csv('park_filter.csv', index=False)

df_filter = pd.read_csv("park_filter.csv", header=0)
df_filter = df_filter[['NAME','LGA_NAME']]
df_filter = df_filter.groupby('LGA_NAME').size().reset_index(name='counts')
df_filter = df_filter.iloc[1:,:]
df_filter['LGA_NAME'] = df_filter['LGA_NAME'].apply(lambda x: x.lower())


lga_code = open('../vic_sal/geo_vic_filter_lga.geojson')
lga_code_json = json.load(lga_code)

park_geojson = {'type':'FeatureCollection','features':[]}
    
for data in lga_code_json['features']:
    name = data['properties']['name']
    matchData = df_filter[df_filter['LGA_NAME'] == name]
    resultFeature = {'type':'Feature','geometry':data['geometry'],'properties': data['properties']}
    if(matchData.empty):
        resultFeature['properties']['total_park'] = '0'
        park_geojson['features'].append(resultFeature)
    else:
        resultFeature['properties']['total_park'] = str(matchData['counts'].values[0])
        park_geojson['features'].append(resultFeature)
park_geojson

with open('park_geojson.geojson', 'w') as fp:
    json.dump(park_geojson, fp)