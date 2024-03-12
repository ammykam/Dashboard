import pandas as pd
import math

# Read the CSV file
df1 = pd.read_csv("bus.csv", header=0)
df2 = pd.read_csv("train.csv", header=0)
df3 = pd.read_csv("tram.csv", header=0)

df_combined = pd.concat([df1,df2,df3])
df_combined = df_combined[[' STOP_NAME']]
df_combined[' STOP_NAME'] = df_combined[' STOP_NAME'].apply(lambda x: x.split('(')[1][:-1].lower())
# df_combined = df_combined.groupby(' STOP_NAME').size().reset_index(name = 'counts')

df4 = pd.read_csv("regional_bus.csv", header=0)
df5 = pd.read_csv("regional_train.csv", header=0)
df6 = pd.read_csv("regional_couch.csv", header=0)

def processData(data):
    clean = ''
    if('(' not in data):
        clean = data.lower()
    else:
        count = data.count('(')
        if(count == 1):
            clean = data.split('(')[1][:-1].lower()
        elif(count == 2):
            indexFirst = data.find('(')
            indexFirst2 = data.find(')')
            indexLast = data.rfind('(')
            indexLast2 = data.find(')')
            if(indexFirst2 > indexLast):
                clean = data[indexFirst+1:indexLast-1].lower()
            else:
                clean = data.split('(')[2][:-1].lower()

        else:
            clean =  data.split('(')[2][:-1].lower()
    return clean

df_combined2 = pd.concat([df4,df5,df6])
df_combined2 = df_combined2[[' STOP_NAME']]
df_combined2[' STOP_NAME'] = df_combined2[' STOP_NAME'].apply(lambda x: processData(x))
df_combined3 = pd.concat([df_combined,df_combined2])
df_combined3 = df_combined3.groupby(' STOP_NAME').size().reset_index(name = 'counts')

import json

ssa_code = open('../vic_sal/geo_vic_filter_lga.geojson')
ssa_code_json = json.load(ssa_code)
ssa_code_json = ssa_code_json['features']

transportation_geojson = {'type':'FeatureCollection','features':[]}

for index, data in df_combined3.iterrows():
    name = data[' STOP_NAME']

    matchData = next((item for item in ssa_code_json for s in item["properties"]['ssa_name'] if name in s),None)
    if(matchData != None):
        resultFeature = [data for data in transportation_geojson['features'] for sub in data['properties']['ssa_name'] if name in sub]
        if(len(resultFeature) != 0):
            resultFeature[0]['properties']['transportation_number'] += data['counts']
        else:
            resultFeature = {'type':'Feature','geometry':matchData['geometry'],'properties': matchData['properties']}
            resultFeature['properties']['transportation_number'] = data['counts']
            transportation_geojson['features'].append(resultFeature)


with open('transportation_geojson.geojson', 'w') as fp:
    json.dump(transportation_geojson, fp)
    