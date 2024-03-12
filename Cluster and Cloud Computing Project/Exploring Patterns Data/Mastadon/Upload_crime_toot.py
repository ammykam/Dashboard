from mastodon import Mastodon
from datetime import datetime, timezone
import couchdb

MASTODON_ACCESS_TOKEN="zYE_TLI2g6JxGBmDiv45Qk1OaQUQN7l5SRvHPRVBlSc"
mastodon = Mastodon(api_base_url="https://mastodon.social", access_token = MASTODON_ACCESS_TOKEN)

# to be used later to be checked with all hashtags
keywords = ["abduction","blackmail","bribery","bombing","corruption","crime","cybercrime","domestic violence",
            "drug","espionage","embezzlement","family violence","felony","forgery","fraud","genocide","gunviolence","kidnapping","hit and run","identify theft","kidnapping",
            "manslaughter","missingperson","murder","rape","robbery","riot","terrorism","theft","trafficking","sexcrimes","scam","smuggling"]

server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984')
db_name = 'mastodon_toots'

if db_name in server:
    del server[db_name] 
    db = server.create(db_name)
else:
    db = server.create(db_name)


def extract_toot(new_toots,tag):
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
        if date_time < current_time:
            exampler_dict["id"] = toot['id']
            exampler_dict["created_at"] = date_time.isoformat()
            exampler_dict["hashtag"] = tag
            exampler_dict["account"] = toot['account']['id']
            if toot["account"]["bot"] == True:
                exampler_dict["bot"] = True
        
            toots.append(exampler_dict)

    return toots


for keyword in keywords:
    tags = mastodon.search(keyword, resolve=True)["hashtags"]

    for tag in tags:
        #print(tag)  
        max_id = None
        while True:
            new_toots = mastodon.timeline_hashtag(tag["name"], limit=40, max_id=max_id) # 40 is the highest you can go :(
            toots = extract_toot(new_toots,tag["name"])
            if not new_toots:
                break
            db.update(toots)
            
            max_id = new_toots[-1]["id"]



