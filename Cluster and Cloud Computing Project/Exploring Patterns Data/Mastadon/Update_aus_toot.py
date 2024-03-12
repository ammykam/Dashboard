from mastodon import Mastodon,StreamListener
from datetime import datetime
import couchdb

MASTODON_ACCESS_TOKEN="j7QZQljDA7H9bcEEqs0TBS_-NehtBK9VY8hh0rQJOYY"
mastodon = Mastodon(api_base_url="https://mastodon.au", access_token = MASTODON_ACCESS_TOKEN)

server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984')
db_name = 'aus_server_mastodon_toots_may_to_dec'

if db_name in server:
    db = server[db_name]
else:
    db = server.create(db_name)

def extract_toot(toot):
    current_time = datetime.now()
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
    

    return [exampler_dict]

class MyStreamListener(StreamListener):
    def on_update(self, toot):
        print(toot['content'])
        toot = extract_toot(toot)
        db.update(toot)

listener = MyStreamListener()
mastodon.stream_local(listener)
