import json
import pandas as pd
import couchdb
import os
from mpi4py import MPI
import zipfile

# Connect to the CouchDB server
server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984/')

# Select the database to use
twitter_file_path = 'twitter-huge.json'

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.size

def node_process(twitter_file_path, c_start, c_end, b_size, db_name):
    batches = []
    db = server[db_name]

    # dividing the chunks to batches
    with open(twitter_file_path, 'rb') as f:
        b_end = c_start
        while b_end < c_end:
            b_start = b_end
            f.seek(b_start + b_size)
            f.readline()
            b_end = f.tell()
            if b_end > c_end:
                b_end = c_end
            batches.append([b_start, b_end - b_start])

    # reading the lines from batches
    with open(twitter_file_path, 'rb') as f:
        for batch in batches:
            docs = []
            # for each batch checking if line has author_id or full_name
            f.seek(batch[0])
            lines = f.read(batch[1]).splitlines()
            for line in lines:
              line = line.decode('utf-8')
              try:
                  line_json = json.loads(line[:-1])
                  text= line_json['doc']['data']['text'].lower()
                  tags=line_json['value']['tags'].lower()
                  key_words=['vivd sydney',"vivid sydney","vivid","vividsydney","vividsydney2022","vividsydney2023","light festival","lightart","lightinstallation","artinstallation","music","performance","harbour","harbourbridge","opera","operahouse","circularquay","the rocks","sydfilmfest","sydney light festival"]
                  if line_json['doc']['data']['context_annotations'][0]['entity']['name']=='VIVID Sydney 2022' or any(item in text for item in key_words)or any(item in tags for item in key_words):
                    sent=line_json['doc']['data']['sentiment']
                    if sent<=-0.3:
                        sentiment='high negative'
                    elif sent<=-0.1 and sent>-0.3:
                        sentiment='negative'
                    elif sent<0.1 and sent>-0.1:
                        sentiment='neutral'
                    elif sent>0.1 and sent<0.3:
                        sentiment='positive'
                    else:
                        sentiment='highly positive'
                    docs.append({
                        'id': line_json['id'],
                        'sentiment': sentiment
                        })
              except:
                  pass
            db.update(docs)
            print(f"Database {db_name} now contains {len(db)} documents.")
if rank == 0:
    total_size = os.path.getsize(twitter_file_path)
    c_size = int(total_size / size)
    chunks = []
    with open(twitter_file_path, 'rb') as f:
        c_start = 0
        while True:
            f.seek(c_start + c_size)
            line = f.readline()  # read until newline character
            if not line:
                # end of file
                chunks.append((c_start, f.tell()))
                break
            else:
                c_end = f.tell()
                chunks.append([c_start, c_end])
                c_start = c_end
    db_name = 'vivid_sydney'
    if db_name in server:
        db = server[db_name]
    else:
        db = server.create(db_name)
else:
    chunks = None
    db_name = ''
comm.Barrier()
chunk_node = comm.scatter(chunks, root=0)
db_name = comm.scatter([db_name, db_name,db_name, db_name], root=0)
node_process(twitter_file_path, chunk_node[0], chunk_node[1], 10000000, db_name)
