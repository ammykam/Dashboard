import couchdb
import matplotlib.pyplot as plt

# Connect to CouchDB database
server = couchdb.Server('http://couchdb:couchdb@172.26.128.239:5984/')
database_name=input('server name')
if database_name=='melbourne_cup':
    db = server['melbourne_cup']
    # define the name of the view and the design document it belongs to
    view_name = 'melbcup'
    design_doc = '_design/melbcup'
    group_level=2
elif database_name=='australian_open': 
    db = server['australian_open']
    # define the name of the view and the design document it belongs to
    view_name = 'sentiment'
    design_doc = '_design/sentiment'
    group_level=2
elif database_name=='vivid_sydney': 
    db = server['vivid_sydney']
    # define the name of the view and the design document it belongs to
    view_name = 'vivid_sydney'
    design_doc = '_design/sentiment_vivid'
    group_level=2
elif database_name=='grand_prix': 
    db = server['grand_prix']
    # define the name of the view and the design document it belongs to
    view_name = 'sentiment_gp'
    design_doc = '_design/sentiment_gp'
    group_level=2
elif database_name=='lgbtq': 
    db = server['lgbtq']
    # define the name of the view and the design document it belongs to
    view_name = 'lgbtq_view'
    design_doc = '_design/lgbtq'
    group_level=2
# retrieve the view
view = db.view(design_doc + '/_view/' + view_name,reduce=True, group_level=group_level)
sentiment=[]
counts=[]
# iterate over the rows in the view and print the key-value pairs
for row in view:
    sentiment.append(row.key)
    counts.append(row.value)

# create the figure and axes objects
fig, ax = plt.subplots()

# create the histogram
ax.bar(sentiment, counts, color='cornflowerblue', edgecolor='black')

# add labels and title
ax.set_xlabel('Sentiment', fontsize=14)
ax.set_ylabel('Count', fontsize=14)
ax.set_title('Sentiment Histogram', fontsize=16)

# add annotations
for i, v in enumerate(counts):
    ax.text(i, v + 1000, str(v), ha='center', fontsize=12)

# set the axis limits
ax.set_ylim([0, max(counts) * 1.1])

# remove the top and right spines
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

# display the histogram
plt.show()

