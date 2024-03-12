#Main
import json
from mpi4py import MPI
import math
import time
import pandas as pd
from collections import Counter
import clean_data as cd

# =====================================================
# ============= 1. Checking Json Objects ==============
# =====================================================

# checkNumberObjects(fileName):
# This function run through the file count the amount of json in the file based on "id:"
# return number of data in the file

def checkNumberObjects(fileName):
    start_time = time.time()
    count = 0
    with open(fileName) as f:
        for line in f:
            if "\"_id\":" in line:
                count = count + 1
    end_time = time.time()
    print("=========")
    print("checkNumberObjects Time:", end_time - start_time)
    print("=========")
    return count

# =====================================================
# ================ 2. Split the data ==================
# =====================================================

# splitData(numberObject, size)
# This function calculates the amount of json to be processed by each cores
# return list of list of start and end json

def splitData(numberObject, size):
    start_time = time.time()
    chunkSize = math.ceil(numberObject/size)
    file_portion = []
    start = 0
    end = chunkSize
    
    for i in range(size):
        if(end > numberObject):
            end = numberObject
        file_portion.append([start,end])
        start = start + chunkSize
        end = end + chunkSize
        
    end_time = time.time()
    print("=========")
    print("Split Time:", end_time - start_time)
    print("=========")
    return file_portion

# =====================================================
# =============== 3. Process the data =================
# =====================================================

# generateData(fileName,file_line, greaterCity)
# This function runs through the data line by line and extract author_id and place name
# It also process the data using cleanPlaces(place) and findCode(place, greaterCity)
# It makes a faster exit if it reaches the end of the file_line
# return process data extracted from json file

def generateData(fileName,file_line, greaterCity):
    start_time = time.time()
    process_data = {}
    count = 0
    key = ''
    place = ''
    with open(fileName) as f:
        for line in f:
            if "\"_id\":" in line:
                count = count + 1
            
            if(count >= file_line[0]) and (count < file_line[1]):
                if "\"author_id\":" in line:
                    key = line[20:].replace("\",","").replace("\n","")
                elif "\"full_name\":" in line:
                    place = line[24:].replace("\",","").replace("\n","")
                if (key) and (place):
                    if key not in process_data:
                        process_data[key] = {}
                        process_data[key]['place'] = []
                        process_data[key]['place_code'] = []
                    place_clean = cd.cleanPlaces(place)
                    process_data[key]['place'].append(place_clean)
                    if(place_clean != ''):
                        place_code = find_code(place_clean,greaterCity)
                        if(place_code != ''):
                            process_data[key]['place_code'].append(place_code)
                    key = ''
                    place = ''
            elif(count == file_line[1]):
                break
            
    end_time = time.time()
    print("=========")
    print("Generate Time:", end_time - start_time)
    print("=========")
    return process_data

# find_code(place, greaterCity)
# This function finds the code of the city.
# Special Case:
# 1. It makes a fast exit if code is found.
# 2. if place has state within it, it will only check that state
# return the code of the city

def find_code(place, greaterCity):
    indexComma = place.find(',')
    fullName0 = place.split(',')[0]
    fullName1 = ''    
    code_result = ''
    for code in greaterCity:
        suburb = greaterCity[code]
        if(indexComma != -1):
            fullName1 = place.split(',')[1]
            if (fullName1 in list(cd.state_abb.values())):
                if(fullName1 == cd.state_abb[code]):
                    if(fullName0 in suburb):
                        code_result = code
                        break
                    else:
                        break
            elif(fullName1 in cd.state_abb[code]):
                if(fullName0 in suburb):
                    code_result = code
                    break
        else:
            if(fullName0 in suburb):
                code_result = code
                break
    
    return code_result

# countData(data)
# This function count the number of tweets based on place and the unique place based on place_code
# return data with more key to process

def countData(data):
    start_time = time.time()
    for key in data:
        if(len(data[key]['place_code']) != 0):
            data[key]['count_unique_place_code'] = Counter(data[key]['place_code'])
        data[key]['#overallTweets'] = len(data[key]['place'])
        data[key].pop('place')
        data[key].pop('place_code')
    end_time = time.time()
    print("=========")
    print("Count Data Time:", end_time - start_time)
    print("=========")
    return data

# process(fileName, file_line, greaterCity)
# This function execute generateData(fileName,file_line, greaterCity) and countData(data)
# return processed data

def process(fileName, file_line, greaterCity):
    process_data = generateData(fileName,file_line, greaterCity)
    final_data = countData(process_data)
    return final_data

# =====================================================
# ================ 4. Show the result =================
# =====================================================


# question1_merge(merge_result)
# This function process merge data to output question 1
# return data frame

def question1_merge(merge_result):
    result = sorted(merge_result.items(), key=lambda d: d[1]['#overallTweets'], reverse = True)[0:10]
    df = pd.DataFrame(result)
    df.columns = ['Author Id', 'Number of Total Tweets Made']
    df['Number of Total Tweets Made']=  df.apply(lambda x: x['Number of Total Tweets Made']['#overallTweets'] , axis =1)
    df['Rank'] = df.reset_index().index + 1
    cols = df.columns.tolist()
    df = df[['Rank','Author Id', 'Number of Total Tweets Made']]
    return df 

# question2_merge(merge_result)
# This function process merge data to output question 2
# return data frame

def question2_merge(merge_result):
    arrange_data = [merge_result[key]['count_unique_place_code'] for key in merge_result if 'count_unique_place_code' in merge_result[key]]
    result = sum(arrange_data, Counter())
    df = pd.DataFrame(list(result.most_common()))
    df.columns = ['Greater Capital City','Number of Total Tweets Made']
    return df 

# question3_merge(merge_result)
# This function process merge data to output question 3
# return data frame

def question3_merge(merge_result):
    arrange_data = [{key: merge_result[key]} for key in merge_result if 'count_unique_place_code' in merge_result[key]]
    df = pd.concat([pd.DataFrame(l) for l in arrange_data],axis=1).T
    df = df.reset_index()
    df = df[['index','count_unique_place_code']]
    df.columns = ['Author Id','Number of Unique City Locations']
    df['Count Tweets in Each City'] = df['Number of Unique City Locations']
    df['Number of Total Tweets Made'] = df.apply(lambda x: sum(x["Number of Unique City Locations"].values()), axis =1)
    df['Number of Unique City Locations']=  df.apply(lambda x: len(x["Number of Unique City Locations"]), axis =1)
    df['Count Tweets in Each City']=  df.apply(lambda x: manageCountTweets(x["Count Tweets in Each City"]), axis =1)
    df = df.sort_values(['Number of Unique City Locations','Number of Total Tweets Made'], ascending=False)
    df['Rank'] = df.reset_index().index + 1
    df = df[['Rank','Author Id','Number of Unique City Locations','Number of Total Tweets Made','Count Tweets in Each City']]
    pd.set_option('display.max_columns', None) 
    pd.set_option('display.max_colwidth', None)
    return df[0:10]

# manageCountTweets(data)
# This function process the Count() object and output the string according to the spec
# return string

def manageCountTweets(data):
    result = ''
    for key, value in data.items():
        if(len(result) != 0):
            result = result + ', ' + '#'+str(value)+key[1:]
        else:
            result = '#'+str(value)+key[1:]
    return result


def main(file):
    start_time = time.time()
    comm = MPI.COMM_WORLD
    size = comm.Get_size()
    rank = comm.Get_rank()
 
    f = open('sal.json')
    suburbData = json.load(f)
    f.close()
    greaterCity = cd.arrangeSuburb(suburbData)
    
    if rank == 0:
        file_to_process = [file]
        numberObject = checkNumberObjects(file)
        file_to_process = splitData(numberObject, size)
    else:
        file_to_process = None
    
    twitterSmall = comm.scatter(file_to_process, root=0)
    print("Rank: {}, file_name: {}".format(rank, twitterSmall))    
    result = process(file ,twitterSmall, greaterCity)
    resultMerge = comm.gather(result, root=0)
    
    if rank == 0:
        start_merge = time.time()
        results = {}
        for x in resultMerge:
            for key in x:
                if key not in results:
                    results[key] = {}
                if ('#overallTweets' in x[key]):
                    if('#overallTweets' in results[key]):
                        results[key]['#overallTweets'] = results[key]['#overallTweets'] + x[key]['#overallTweets']
                    else:
                        results[key]['#overallTweets'] = x[key]['#overallTweets']
                if('count_unique_place_code' in x[key]):
                    if('count_unique_place_code' in results[key]):
                        results[key]['count_unique_place_code'] = results[key]['count_unique_place_code'] + x[key]['count_unique_place_code']
                    else:
                        results[key]['count_unique_place_code'] = x[key]['count_unique_place_code']
    
        df = question1_merge(results)
        df2 = question2_merge(results)
        df3 = question3_merge(results)
        end_time = time.time()
        print("=========")
        print("Merge Time:", end_time - start_merge)
        print("=========")
        print("=========")
        print("Total Time:", end_time - start_time)
        print("=========")
        print(df)
        print(df2)
        print(df3)
        print('\n\n')
    
main('bigTwitter.json')
