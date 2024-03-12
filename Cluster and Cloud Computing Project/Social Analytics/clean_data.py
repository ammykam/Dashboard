

state_abb = {'1gsyd':'nsw', '2gmel':'vic','3gbri':'qld','4gade':'sa','5gper':'wa','6ghob':'tas', '7gdar':'nt','8acte':'act', '9oter':'ter'}
state_name = {'newsouthwales':13, 'victoria':8,'queensland':10,'southaustralia':14,'westernaustralia':16,'tasmania':8, 'northernterritory':25,'australiancapitalterritory':26,'otherterritory':14}
state_abb_clean = {',newsouthwales':',nsw', ',victoria':',vic',',queensland':',qld',',southaustralia':',sa',',westernaustralia':',wa',',tasmania':',tas', ',northernterritory':',nt',',australiancapitalterritory':',act',',otherterritory':'ter'}
state_cap = {',sydney':',nsw', ',melbourne':',vic',',brisbane':',qld',',adelaide':',sa',',perth':',wa',',hobart':',tas', ',darwin':',nt',',canberra':',act'}


# =====================================================
# ============ Method to Help Clean Data ==============
# =====================================================

# arrangeSuburb(suburbData):
# This method helps rearrange sal.json data, which match those in greater city area only.
# In our case, we match 9 greater city area listed as below.
# We also remove any () from the suburb name.

# Special Case:
# We remove perth and canberra with other extension like (sa.) and the code is the same, so we remove those value out

def arrangeSuburb(suburbData):
    greaterCity = {
    '1gsyd': [],  # Sydney:
    '2gmel': [],  # Melbourne:
    '3gbri': [],  # Brisbane:
    '4gade': [],  # Adelaide:
    '5gper': [],  # Perth:
    '6ghob': [],  # Hobart:
    '7gdar': [],  # Darwin:
    '8acte': [],  # Canberra:
    '9oter': []   # No capital
    }
    for key, value in suburbData.items():
        gcc = value['gcc']
        if gcc in greaterCity:
            if key != gcc[1:] and key != 'perth' and key != 'canberra':
                greaterCity[gcc].append(key.replace(' ','').split('(')[0])
    return greaterCity


# cleanPlaces(data):
# From value "place" in twitter data file, it it being processed through this function
# Case:
# 1. remove those with "australia" keyword, as we could not identify the suburb or city
# 2. abbreviate the state name to shorter version
# 3. replace those with capital city as their second place to its proper state instead, 
# which would not cover those case with non-capital place name. For example, it could
# turn "richmond,sydney" to "richmond,nsw" but could not turn "richmond,bondi" to its
# correct state

def cleanPlaces(data):
    place = data.replace(' ','').lower()
    
    if('australia' in place and len(place) == 9):
        place = place.replace('australia','')
    elif(',australia' in place and ',australiancapitalterritory' not in place):
        place = place.replace(',australia','')
    place = place.strip()
    if(place in state_name.keys() and len(place) == state_name[place]):
        place = place.replace(place,'')
    for key in state_abb_clean:
        if(key in place):
            place = place.replace(key,state_abb_clean[key])
    for key in state_cap:
        if(key in place):
            place = place.replace(key,state_cap[key])
    return place
