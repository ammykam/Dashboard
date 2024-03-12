from mastodon import Mastodon,StreamListener
from datetime import datetime
import couchdb
import time


MASTODON_ACCESS_TOKEN="zYE_TLI2g6JxGBmDiv45Qk1OaQUQN7l5SRvHPRVBlSc"
mastodon = Mastodon(api_base_url="https://mastodon.social", access_token = MASTODON_ACCESS_TOKEN)


# to be used later to be checked with all hashtags
keywords = ["abduction","blackmail","bribery","bombing","corruption","crime","cybercrime","domestic violence",
            "drug","espionage","embezzlement","family violence","felony","forgery","fraud","genocide","gunviolence","kidnapping","hit and run","identify theft","kidnapping",
            "manslaughter","missingperson","murder","rape","robbery","riot","terrorism","theft","trafficking","sexcrimes","scam","smuggling"]

server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984')
db_name = 'mastodon_toots'

if db_name in server:
    db = server[db_name]
else:
    db = server.create(db_name)


def get_most_recent_toot_date():
    ## Use map reduce to create view so we can find the most recent toot in the current database
    map_fun = '''function(doc) {
        if('created_at' in doc) {
            emit(doc.created_at, doc);
        }
    }'''

    design = {
        '_id': '_design/my_design_doc',
        'views': {
            'by_created_at': {
                'map': map_fun
            }
        }
    }

    # Delete the existing design document if it exists
    if design['_id'] in db:
        del db[design['_id']]

    db.save(design)
    results = db.view('my_design_doc/by_created_at', descending=True, limit=1)
    toot_date = datetime.strptime(results.rows[0].value['created_at'], '%Y-%m-%dT%H:%M:%S')
    return toot_date


def extract_toot(new_toots,tag, most_recent_toot):
    current_time = datetime.now()
    toots = []
    for toot in new_toots:
        exampler_dict = {
            "id":"",
            "created_at": "",
            "hashtag": "",
            "account" ""
            "bot": False
        }
        ## convert type to date_time(need to due to json format)
        date_time = toot["created_at"].replace(tzinfo=None)
        if date_time < current_time and date_time > most_recent_toot:
            exampler_dict["id"] = toot['id']
            exampler_dict["created_at"] = date_time.isoformat()
            exampler_dict["hashtag"] = tag
            exampler_dict["account"] = toot['account']['id']
            if toot["account"]["bot"] == True:
                exampler_dict["bot"] = True
        
            toots.append(exampler_dict)

    return toots


while True:
    most_recent_toot = get_most_recent_toot_date()
    for keyword in keywords:
        tags = mastodon.search(keyword, resolve=True)["hashtags"]

        for tag in tags:
            max_id = None
            while True:
                new_toots = mastodon.timeline_hashtag(tag["name"], limit=40, max_id=max_id) # 40 is the highest you can go :(
                toots = extract_toot(new_toots,tag["name"],most_recent_toot)
                if not new_toots or not toots:
                    break
                db.update(toots)
                
                max_id = new_toots[-1]["id"]
    time.sleep(60 * 60 * 24) # Update Hashtags every single day