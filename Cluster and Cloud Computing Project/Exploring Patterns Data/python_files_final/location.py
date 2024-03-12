import json
import pandas as pd
import couchdb
import os
from mpi4py import MPI
import zipfile

# Connect to the CouchDB server
server = couchdb.Server('http://couchdb:couchdb@172.26.133.92:5984/')

# Select the database to use


comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.size

def cleanPlaces(data):
    place = data.replace(' ','').lower()
    #if victoria is present in the word (exclude something like victoria point)
    if(',victoria' in place) or ('victoria' in place and len(place) == 8):
        place = place.replace(',victoria','')
        place = place.replace(',melbourne','')
    else:
        place = ''
    return place

twitter_file_path='twitter-huge.json'

def generateData(twitter_file_path,c_start,c_end,b_size,db_name):
    
    f = open('geo_vic_filter.json')
    geo_vic = json.load(f)
    batches=[]
    db = server[db_name]
   #dividing the chunks to batches 
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
    process_data = {}
    with open(twitter_file_path, 'rb') as f:
        for batch in batches:
            docs=[]
            f.seek(batch[0])
            lines = f.read(batch[1]).splitlines()
            for line in lines:
                jsonLine = line.decode('utf-8')
                try:
                    jsonLine = json.loads(jsonLine[:-1])
                    if('includes' in jsonLine['doc']):        
                        place = cleanPlaces(jsonLine['doc']['includes']['places'][0]['full_name'])
                        if(place != ''):
                            process_data['id'] = jsonLine['id']
                            process_data['dates'] = jsonLine['doc']['data']['created_at']
                            process_data['tokens'] = jsonLine['value']['tokens']
                            sentiment = jsonLine['doc']['data']['sentiment']
                            process_data['sentiment'] = 1 if sentiment > 0 else (0 if sentiment == 0 else -1)
                            process_data['places'] = place
                            if(place in geo_vic):
                                matched_data = [geo_vic[data] for data in geo_vic if place in data][0]
                                process_data['lat'] = matched_data['lat']
                                process_data['lon'] = matched_data['lon']
                                docs.append(process_data)
                                process_data={}
                except:
                    pass
            db.update(docs)
            print(f"Database {db_name} now contains {len(db)} documents.")
   
if rank == 0:
  total_size = os.path.getsize(twitter_file_path)
  print(total_size)
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
  db_name = 'location_data'
  if db_name in server:
    db = server[db_name]
  else:
    db = server.create(db_name)
else:
  chunks = None
  db_name=''

print(chunks)
comm.Barrier()
chunk_node = comm.scatter(chunks, root=0)
db_name=comm.scatter([db_name,db_name,db_name,db_name],root=0)
generateData(twitter_file_path,chunk_node[0],chunk_node[1],1000000,db_name)

