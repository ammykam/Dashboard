import json
import pandas as pd
import couchdb
import os
from mpi4py import MPI
import zipfile
import datetime

# Connect to the CouchDB server
server = couchdb.Server('http://couchdb:couchdb@172.26.134.221:5984/')

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
    batch_counter=0
    # reading the lines from batches
    with open(twitter_file_path, 'rb') as f:
        for batch in batches:
            print(batch_counter)
            if batch_counter>3000000:
              break
            docs = []
            # for each batch checking if line has author_id or full_name
            f.seek(batch[0])
            lines = f.read(batch[1]).splitlines()
            for line in lines:
              line = line.decode('utf-8')
              try:
                  line_json = json.loads(line[:-1])
                  created_at = line_json["doc"]["data"]["created_at"]
                  created_at_datetime = datetime.datetime.strptime(created_at, "%Y-%m-%dT%H:%M:%S.%fZ")
                  created_at_date = created_at_datetime.date()
                  created_at_time = created_at_datetime.time()
                  if created_at_date.month ==2:
                      batch_counter+=1
                      docs.append({
                          'id': line_json['id'],
                          'created_month': created_at_date.month,
                          'created_day': created_at_date.day,
                          'created_hour': created_at_time.hour,
                          'created_at': created_at
                          })
                  if batch_counter>3000000:
                      break
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
    db_name = 'time_analysis'
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
