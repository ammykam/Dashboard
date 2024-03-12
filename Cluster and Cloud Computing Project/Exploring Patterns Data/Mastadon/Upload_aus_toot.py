from mastodon import Mastodon
from datetime import datetime
import couchdb

MASTODON_ACCESS_TOKEN="j7QZQljDA7H9bcEEqs0TBS_-NehtBK9VY8hh0rQJOYY"
mastodon = Mastodon(api_base_url="https://mastodon.au", access_token = MASTODON_ACCESS_TOKEN)

server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984')
db_name = 'aus_server_mastodon_toots_may_to_dec'
if db_name in server:
    del server[db_name] 
    db = server.create(db_name)
else:
    db = server.create(db_name)
    

def extract_toot(new_toots):
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
            exampler_dict["account"] = toot['account']['id']
            if toot["account"]["bot"] == True:
                exampler_dict["bot"] = True
        
            toots.append(exampler_dict)

    return toots


max_id = None

iteration = 99999
for i in range(iteration):
    new_toots = mastodon.timeline_local(limit=40, max_id=max_id)
    if new_toots:
        toots = extract_toot(new_toots)
        db.update(toots)
        max_id = new_toots[-1]['id']
    else:
        break


