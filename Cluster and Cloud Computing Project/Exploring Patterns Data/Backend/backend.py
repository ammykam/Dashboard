# export FLASK_APP=backend.py
import couchdb
from flask import Flask, jsonify
from flask_cors import CORS, cross_origin
import json
from dotenv import load_dotenv
from pathlib import Path
import os

dotenv_path = Path('.envdb_api')
load_dotenv(dotenv_path=str(dotenv_path))

dbuser = os.getenv("DBuser")
dbpwd = os.getenv("DBpwd")
dburl = os.getenv("DBurl")
dburl2 = os.getenv("DBurl2")
dburl3= os.getenv("DBurl3")
dburl4= os.getenv("DBurl4")

server = couchdb.Server("http://" + dbuser +":"+dbpwd +"@" + dburl)
server2= couchdb.Server("http://" + dbuser +":"+dbpwd +"@" + dburl2)
server3= couchdb.Server("http://" + dbuser +":"+dbpwd +"@" + dburl3)
server4= couchdb.Server("http://" + dbuser +":"+dbpwd +"@" + dburl4)

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

@app.route("/")
@cross_origin()
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/australian-open")
@cross_origin()
def getAustraliaOpen():
    db = server['australian_open']

    view = db.view('sentiment/sentiment',group= True)
    response = []

    for row in view:
        response.append({row.key:row.value})

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/grand-prix")
@cross_origin()
def getGrandprix():
    db = server['grand_prix']

    view = db.view('sentiment_gp/sentiment_gp',group= True)
    response = []

    for row in view:
        response.append({row.key:row.value})

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/lgbtq")
@cross_origin()
def getLGBTQ():
    db = server['lgbtq']

    view = db.view('lgbtq/lgbtq_view',group= True)
    response = []

    for row in view:
        response.append({row.key:row.value})

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/melbourne-cup")
@cross_origin()
def getMelbcup():
    db = server['melbourne_cup']

    view = db.view('melbcup/melbcup',group= True)
    response = []

    for row in view:
        response.append({row.key:row.value})

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/vivid-sydney")
@cross_origin()
def getVividSydney():
    db = server['vivid_sydney']

    view = db.view('sentiment_vivid/vivid_sydney',group= True)
    response = []

    for row in view:
        response.append({row.key:row.value})

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime", methods = ["GET"])
@cross_origin()
def getCrime():
    db = server2['crime']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-no-location", methods = ["GET"])
@cross_origin()
def getCrimeNoLocation():
    db = server2['crime']
    view = db.view('crime/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/domestic-violence", methods = ["GET"])
@cross_origin()
def getDV():
    db = server2['domestic_violence']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/domestic-violence-no-location", methods = ["GET"])
@cross_origin()
def getDVNoLocation():
    db = server2['domestic_violence']
    view = db.view('domestic_violence/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/park", methods = ["GET"])
@cross_origin()
def getPark():
    db = server2['park']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/park-no-location", methods = ["GET"])
@cross_origin()
def getParkNoLocation():
    db = server2['park']
    view = db.view('park/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/population", methods = ["GET"])
@cross_origin()
def getPopulation():
    db = server2['population']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/population-no-location", methods = ["GET"])
@cross_origin()
def getPopulationNoLocation():
    db = server2['population']
    view = db.view('population/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/salary", methods = ["GET"])
@cross_origin()
def getSalary():
    db = server2['salary']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/salary-no-location", methods = ["GET"])
@cross_origin()
def getSalaryNoLocation():
    db = server2['salary']
    view = db.view('salary/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/transportation", methods = ["GET"])
@cross_origin()
def getTransportation():
    db = server2['transportation']
    response = {"type": "FeatureCollection","features":[]}

    for docid in db.view('_all_docs'):
        data = db[docid['id']]
        response['features'].append(data)

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/transportation-no-location", methods = ["GET"])
@cross_origin()
def getTransportationNoLocation():
    db = server2['transportation']
    view = db.view('transportation/no_location')
    response = []

    for row in view:
        response.append(row['key'])

    response = jsonify(response)

    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/location-data", methods = ["GET"])
@cross_origin()
def getLocationData():
    db = server2['location_data']

    view = db.view('location/coordinates',group= True)

    response = []

    for row in view:
        response.append({row.key[0]:{"lat":row.key[1],"lon":row.key[2]}})

    view = db.view('location/overall_score',group= True)

    final_response = []

    for row in view:
        place = row.key[0]
        currentData = [data for data in response if place in data][0]
        score = row.key[1]
        if(score == -1):
            currentData[place]['negative'] = row.value
        elif(score == 0):
            currentData[place]['neutral'] = row.value
        else:
            currentData[place]['positive'] = row.value
        final_response.append(currentData)

    for index, value in enumerate(final_response):
        for key in value:
            currentData = final_response[index][key]
            if('positive' not in currentData):
                final_response[index][key]['positive'] = 0
            if('neutral' not in currentData):
                final_response[index][key]['neutral'] = 0
            if('negative' not in currentData):
                final_response[index][key]['negative'] = 0
        final_response[index][key]['total'] = final_response[index][key]['positive'] + final_response[index][key]['neutral'] +final_response[index][key]['negative']

    format_response = {'fields':[{'name':'places','format':'','type':'string'},\
    {'name':'lat','format':'','type':'real'},{'name':'lon','format':'','type':'string'},\
    {'name':'negative','format':'','type':'interger'},{'name':'neutral','format':'','type':'interger'},\
    {'name':'poitive','format':'','type':'interger'},{'name':'total','format':'','type':'interger'}],\
    'rows':[]}

    for data in final_response:
        for key in data:
            currentData = data[key]
            format_response['rows'].append([key, currentData['lat'],currentData['lon'],currentData['negative'],currentData['neutral'],currentData['positive'], currentData['total']])

    response = jsonify(format_response)


    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/location-overall", methods = ["GET"])
@cross_origin()
def getLocationOverall():
    db = server2['location_data']
 

    view = db.view('location/sentiment_overall',group= True)
    response = []

    for row in view:
        if(row.key == 0):
            response.append({'neutral':row.value})
        elif(row.key == 1):
            response.append({'positive':row.value})
        else:
            response.append({'negative':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/location-sentiment", methods = ["GET"])
@cross_origin()
def getLocationSentiment():
    db = server2['location_data']
    db_crime = server['crime']

    view_crime = db_crime.view('crime/no_location')

    ssa_lga = []

    for row in view_crime:
        ssa_lga.append({row.key['name']:row.key['ssa_name']})

    view = db.view('location/overall_score',group= True)
    response = []

    for row in view:
        place = row.key[0]
        score = row.key[1]

        lga = [key for data in ssa_lga for key in data if place in data[key]]


        if(len(lga) != 0):
            place = lga[0]
        else:
            place = 'east gippsland'



        currentData = [data for data in response if place in data]

        if(len(currentData) == 0):
            currentData = {place:{'negative':0,'positive':0,'neutral':0}}
            if(score == -1):
                currentData[place]['negative'] +=row.value
            elif(score == 0):
                currentData[place]['neutral'] += row.value
            else:
                currentData[place]['positive'] += row.value
            response.append(currentData)
        else:
            currentData = currentData[0]
            if(score == -1):
                currentData[place]['negative'] +=row.value
            elif(score == 0):
                currentData[place]['neutral'] += row.value
            else:
                currentData[place]['positive'] += row.value



    for index, value in enumerate(response):
        for key in value:
            response[index][key]['total'] = response[index][key]['positive'] + response[index][key]['neutral'] +response[index][key]['negative']


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/location-positive", methods = ["GET"])
@cross_origin()
def getLocationPositive():
    db = server3['location_data']

    view = db.view('location/overall_score',group= True)
    response = []

    for row in view:
        if(row.key[1] == 1):
            response.append({row.key[0]:row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/location-negative", methods = ["GET"])
@cross_origin()
def getLocationNegative():
    db = server3['location_data']

    view = db.view('location/overall_score',group= True)
    response = []

    for row in view:
        if(row.key[1] == -1):
            response.append({row.key[0]:row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/location-neutral", methods = ["GET"])
@cross_origin()
def getLocationNeutral():
    db = server3['location_data']

    view = db.view('location/overall_score',group= True)
    response = []

    for row in view:
        if(row.key[1] == 0):
            response.append({row.key[0]:row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-twitter-month", methods = ["GET"])
@cross_origin()
def getCrimeMonth():
    db = server3['crime_twitter']

    view = db.view('crime_twitter/month_on_month',group= True)
    response = []

    for row in view:
        currentData = row.key
        currentData['value'] = row.value
        response.append(currentData)


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/crime-twitter-day", methods = ["GET"])
@cross_origin()
def getCrimeDay():
    db = server3['crime_twitter']

    view = db.view('crime_twitter/day_of_month',group= True)
    response = []

    for row in view:
        day = row.key['day']
        value = row.value
        currentData = []
        currentData = [index for index, data in enumerate(response) if (day == data['day'])]


        if(len(currentData) == 0):
            response.append({'day':day, 'value':value})
        else:
            response[currentData[0]]['value'] += value



    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-twitter-hour", methods = ["GET"])
@cross_origin()
def getCrimeHour():
    db = server['crime_twitter']

    view = db.view('crime_twitter/hours',group= True)
    response = []

    for row in view:
        response.append({'hour':row.key, 'value':row.value})

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-twitter-dow", methods = ["GET"])
@cross_origin()
def getCrimeDow():
    db = server['crime_twitter']

    view = db.view('crime_twitter/twitter_data_dow',group= True)
    response = []

    for row in view:
        response.append({'dow':row.key, 'value':row.value})

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-mastodon-month", methods = ["GET"])
@cross_origin()
def getCrimeMastonDonMonth():
    db = server3['mastodon_toots']

    view = db.view('mastadon_crime_day/mastadon_crime_month_on_month',group= True)
    response = []

    for row in view:
        currentData = row.key
        currentData['value'] = row.value
        response.append(currentData)


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-mastodon-day", methods = ["GET"])
@cross_origin()
def getCrimeMastodonDay():
    db = server3['mastodon_toots']

    view = db.view('mastadon_crime_day/mastadon_crime_day_of_month',group= True)
    response = []

    for row in view:
        day = row.key['day']
        value = row.value
        currentData = []
        currentData = [index for index, data in enumerate(response) if (day == data['day'])]


        if(len(currentData) == 0):
            response.append({'day':day, 'value':value})
        else:
            response[currentData[0]]['value'] += value

    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-mastodon-hour", methods = ["GET"])
@cross_origin()
def getCrimeMastonDonHour():
    db = server['mastodon_toots']

    view = db.view('mastadon_crime_day/hours',group= True)
    response = []

    for row in view:
        response.append({'hour':row.key, 'value':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/crime-mastodon-dow", methods = ["GET"])
@cross_origin()
def getCrimeMastonDonDow():
    db = server['mastodon_toots']

    view = db.view('mastadon_crime_day/crime_toots_day_of_the_week',group= True)
    response = []

    for row in view:
        response.append({'dow':row.key, 'value':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response


@app.route("/time-mastodon-dow", methods = ["GET"])
@cross_origin()
def getTimeMastodonDow():
    db = server3['aus_server_mastodon_toots_may_to_dec']

    view = db.view('all_toots/all_toots_day_of_the_week',group= True)
    response = []

    for row in view:
        response.append({'label':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/time-mastodon-hour", methods = ["GET"])
@cross_origin()
def getTimeMastodonHour():
    db = server3['aus_server_mastodon_toots_may_to_dec']

    view = db.view('all_toots/all_toots_hours',group= True)
    response = []

    for row in view:
        response.append({'x':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/time-mastodon-weekend", methods = ["GET"])
@cross_origin()
def getTimeMastodonWeekend():
    db = server3['aus_server_mastodon_toots_may_to_dec']

    view = db.view('all_toots/all_toots_weekday_weekend',group= True)
    response = []

    for row in view:
        response.append({'label':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/time-tweet-dow", methods = ["GET"])
@cross_origin()
def getTimeTweetDow():
    db = server4['time_analysis_all']

    view = db.view('time/days_of_the_week',group= True)
    response = []

    for row in view:
        response.append({'label':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/time-tweet-hour", methods = ["GET"])
@cross_origin()
def getTimeTweetHour():
    db = server['time_analysis_all']

    view = db.view('time/hours',group= True)
    response = []

    for row in view:
        response.append({'x':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response

@app.route("/time-tweet-weekend", methods = ["GET"])
@cross_origin()
def getTimeTweetWeekend():
    db = server2['time_analysis_all']

    view = db.view('time/time',group= True)
    response = []

    for row in view:
        response.append({'label':row.key, 'y':row.value})


    response = jsonify(response)
    # response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Credentials', '*')
    return response



if __name__ == "__main__":
    app.run(host="0.0.0.0")

