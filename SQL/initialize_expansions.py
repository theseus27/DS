from db import connect
import pandas as pd

def insert_one(db, name, query):
    db.reconnect()
    cursor = db.cursor()
    try:
        cursor.execute(query)
        db.commit()
        print("Inserted " + name)
    except:
        print("FAILED to insert " + name + "    query: " + query) 
    finally:
        cursor.close()
        pass

def initialize_expansions(df, db):
    print(len(df))

    for i in range(len(df)):
        id = df.iloc[i]['id']
        name = df.iloc[i]['name']
        releasedate = df.iloc[i]['releaseDate']
        series = df.iloc[i]['series']
        total = df.iloc[i]['printedTotal']
        fulltotal = df.iloc[i]['total']

        releasedate = releasedate.replace('/', '-')
        if (name == "Champion's Path"): name = "Champions Path"
        if (name == "Sword & Shield"): name = "Sword and Shield"

        query = "INSERT INTO expansions VALUES (\'"+ str(id) + "\', \'" + str(name) + "\', \'" + str(releasedate) + "\', \'" + str(series) + "\', " + str(total) + ", " + str(fulltotal) + ");"
        print(query)
        insert_one(db, name, query)

def readfile(db):
    # Read into dataframe
    df = pd.read_json('setlist.json')

    # Get rid of extraneous columns
    fields_to_keep = ['id', 'name', 'series', 'printedTotal', 'total', 'ptcgoCode', 'releaseDate']
    mylist = list(df)
    for col in mylist:
        if col not in fields_to_keep:
            df.drop(col, axis=1, inplace=True)
    #print(df.columns)

    # Get rid of extraneous rows
    ids_to_keep = ['swsh1', 'swsh2', 'swsh3', 'swsh35', 'swsh4', 'swsh45', 'swsh5', 'swsh6', 'swsh7', 'cel25', 'swsh8', 'swsh9', 'swsh10', 'pgo', 'swsh11', 'swsh12', 'swsh12pt5' 'sv1', 'sv2']
    # df.set_index('id')
    numrows = len(df)
 
    for i in range(numrows):
        if df.loc[i]['id'] not in ids_to_keep:
            df.drop(i, axis=0, inplace=True)
    
    initialize_expansions(df, db)