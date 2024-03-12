import pandas as pd
import time
from mpi4py import MPI
import time
import re
from collections import Counter
import os
import warnings
import json
#changing format and supressing warning if any
warnings.simplefilter(action='ignore', category=FutureWarning)
pd.set_option('display.max_columns', 500)
pd.set_option('max_colwidth', 800)

#reading the Twitter file
twitter_file_path='/Users/yueningteoh/Desktop/CCCA2/twitter处理/twitter-small.json'

def node_process(twitter_file_path,c_start,c_end,b_size):
  len_dict = 0
  small_dict = []
  batches=[]
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

  #reading the lines from batches
  with open(twitter_file_path, 'rb') as f:
    for batch in batches:
      # for each batch checking if line has author_id or full_name
      f.seek(batch[0])
      lines = f.read(batch[1]).splitlines()
      for line in lines:
        #extracting line
        line = line.decode('utf-8')
        if re.match(r'^\s{6}"id":\s*"\d+"', line):
          if len_dict >= 1:
             small_dict.append(small)
          id = (re.findall('[0-9]+', line.strip()))
          small = {}
          small[id[0]] = {}
          len_dict += 1
        if 'author_id' in line.strip():
          aid=(re.findall('[0-9]+', line.strip()))
          small[id[0]]['author_id'] = aid[0]
        if 'tokens' in line.strip():
          tokens = re.findall(r'(?<=: ")(.*?)(?=")', line.strip())
          small[id[0]]['tokens'] = tokens[0]
        if 'created_at' in line.strip():
          date_time = re.findall(r'(?<=: ")(.*?)(?=")', line.strip())
          small[id[0]]['created_at'] = date_time[0]
        if '                \"name\"' in line:
          domain_name = re.findall(r'(?<=: ")(.*?)(?=")', line.strip())
          if 'domain_name' in small[id[0]]:
             small[id[0]]['domain_name'].append(domain_name[0])
          else:
             small[id[0]]['domain_name'] = [domain_name[0]]
        # location
        if 'full_name' in line.strip():
            place=re.findall('(?<=: ")(.*?)(?=")',line.strip())
            small[id[0]]['place'] = place[0]
        if '          \"lang\"' in line:
            lang=re.findall('(?<=: ")(.*?)(?=")',line.strip())
            small[id[0]]['lang'] = lang[0]
        if '          \"text\"' in line:
           text=re.findall('(?<=: ")(.*?)(?=")',line.strip())
           small[id[0]]['text'] = text[0]
        if '          \"sentiment\"' in line:
           sentiment=re.findall(r'[-+.0-9]+', line.strip())
           small[id[0]]['sentiment'] = sentiment[0]
        if 'tag' in line.strip() and 'hashtags' not in line.strip():
          tag=re.findall(r'(?<=: ")(.*?)(?=")', line.strip())
          if 'tag' in small[id[0]]:
             small[id[0]]['tag'].append(tag[0])
          else:
             small[id[0]]['tag'] = [tag[0]]
        if 'description' in line.strip():
          des=re.findall(r'(?<=: ")(.*?)(?=")', line.strip())
          if 'description' in small[id[0]]:
             small[id[0]]['description'].append(des[0])
          else:
             small[id[0]]['description'] = [des[0]]
      
  return small_dict

# Declaring MPI variables
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.size

# Master node will scatter chunk size and chunk start position to all the nodes
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
          elif 'matching_rules' not in line.decode('utf-8'):
            # While loop to make sure we finish reading the whole matching_rules
            while True:
              line=f.readline()
              if b'matching_rules'in line:
                lines_to_finish_this = 7
                while lines_to_finish_this > 0:
                    line = f.readline()
                    lines_to_finish_this -= 1
                pos=f.tell()
                break
            c_end = pos
            chunks.append([c_start, c_end])
            c_start = c_end
else:
  chunks = None

comm.Barrier()

#scatter all chunk information
chunk_node = comm.scatter(chunks, root=0)
#call node process function to produce node results
small_dict=node_process(twitter_file_path,chunk_node[0],chunk_node[1],100000)

#Gathring all variables at root node
small_dict = comm.gather(small_dict, root = 0)
print(small_dict)

with open('/Users/yueningteoh/Desktop/CCCA2/twitter处理/processed_2.json', 'w') as f:
    json.dump(small_dict, f)