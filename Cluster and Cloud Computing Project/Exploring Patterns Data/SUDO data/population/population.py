import pandas as pd
import math

# Read the CSV file
df = pd.read_csv("population.csv", header=0)
df = df[df['lga_code'].notnull()]
df['lga_code'] = df['lga_code'].astype(int).astype(str)

columns = df.columns

columns_elder = [data for data in columns if("x75" in data) or ("x65" in data) or ("x70" in data) or ("x80" in data) or ("x60" in data)]
columns_adult = [data for data in columns if("x40" in data) or ("x45" in data) or ("x50" in data) or ("x55" in data)]
columns_teen = [data for data in columns if("x15" in data) or ("x20" in data) or ("x25" in data) or ("x30" in data)or ("x35" in data)]
columns_child = [data for data in columns if("x0" in data) or ("x5" in data) or ("x10" in data)]

columns_fem_elder = [data for data in columns_elder if("fem" in data)]
columns_mal_elder = [data for data in columns_elder if("mal" in data)]

columns_fem_adult = [data for data in columns_adult if("fem" in data)]
columns_mal_adult = [data for data in columns_adult if("mal" in data)]

columns_fem_teen = [data for data in columns_teen if("fem" in data)]
columns_mal_teen = [data for data in columns_teen if("mal" in data)]

columns_fem_child = [data for data in columns_child if("fem" in data)]
columns_mal_child = [data for data in columns_child if("mal" in data)]

def processData(data):
    data['fem_elder'] = data[columns_fem_elder].sum()
    data['fem_adult'] = data[columns_fem_adult].sum()
    data['fem_teen'] = data[columns_fem_teen].sum()
    data['fem_child'] = data[columns_fem_child].sum()

    data['mal_elder'] = data[columns_fem_elder].sum()
    data['mal_adult'] = data[columns_fem_adult].sum()
    data['mal_teen'] = data[columns_fem_teen].sum()
    data['mal_child'] = data[columns_fem_child].sum()

    data['total_elder'] = data['fem_elder'] + data['mal_elder']
    data['total_adult'] = data['fem_adult'] + data['mal_adult']
    data['total_teen'] = data['fem_teen'] + data['mal_teen']
    data['total_child'] = data['fem_child'] + data['mal_child']

    return data
    
df = df.apply(lambda x: processData(x), axis = 1)
df = df[['lga_code','all_person','all_female','all_male','fem_elder','fem_adult','fem_teen','fem_child','mal_elder','mal_adult','mal_teen','mal_child','total_elder','total_adult','total_teen','total_child']]

import json

lga_code = open('../vic_sal/geo_vic_filter_lga.geojson')
lga_code_json = json.load(lga_code)

population_geojson = {'type':'FeatureCollection','features':[]}
    
for data in lga_code_json['features']:
    code = data['properties']['code']
    matchData = df[df['lga_code'] == code]
    resultFeature = {'type':'Feature','geometry':data['geometry'],'properties': data['properties']}
    if(matchData.empty == False):
        for data in matchData:
            if(data != 'lga_code'):
                resultFeature['properties'][data] = str(matchData[data].values[0])
        population_geojson['features'].append(resultFeature)

with open('population_geojson.geojson', 'w') as fp:
    json.dump(population_geojson, fp)