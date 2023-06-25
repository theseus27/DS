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

def initialize_expansion(df, db):
    #print(len(df))

    for i in range(len(df)):
    
        cardID = df.iloc[i]['id']
        cardName = df.iloc[i]['name']
        rarity = df.iloc[i]['rarity']
        expansion = df.iloc[i]['Expansion']
        setNumber = df.iloc[i]['number']
        cardType = df.iloc[i]['supertype']

        cardName = cardName.replace('\'', '')

        pokemonType = "NULL"
        pokemonName = "NULL"
        hp = "NULL"
        trainerType = "NULL"

        subtype = df.iloc[i]['subtypes'][0]

        if cardType == 'Pokémon':
            pokemonType = df.iloc[i]['types'][0]
            if pokemonType == "Metal":
                pokemonType = "Steel"
            if pokemonType == "Darkness":
                pokemonType = "Dark"
            if pokemonType == "Colorless":
                pokemonType = "Normal"
            if pokemonType == "Lightning":
                pokemonType = "Electric"

            pokemonName = cardName
            hp = df.iloc[i]['hp']
        elif cardType == 'Trainer':
            trainerType = subtype
        elif cardType == 'Energy':
            cardType = "Trainer"
            trainerType = "Energy"
        else:
            print("ERROR INVALID CARD TYPE")

        query = "INSERT INTO cards VALUES (\'"+ str(cardID) + "\', \'" + str(cardName) + "\', \'" + str(cardType) + "\', \'" + str(rarity) + "\', \'" + str(pokemonType) + "\', \'" + str(pokemonName) + "\', " + str(hp) + ", \'" + str(trainerType) + "\', \'" + str(expansion) + "\', " + str(setNumber) + ");"

        insert_one(db, cardName, query)

def read_expansion(db, expansion_name, filename):
    # Read into dataframe
    df = pd.read_json(filename)

    # Get rid of extraneous columns
    fields_to_keep = ['id', 'name', 'supertype', 'subtypes', 'hp', 'types', 'number', 'rarity']

    mylist = list(df)
    for col in mylist:
        if col not in fields_to_keep:
            df.drop(col, axis=1, inplace=True)
    #print(df.columns)

    # df.set_index('id')
    numrows = len(df)

    df['Expansion'] = expansion_name
    
    print(len(df))
    initialize_expansion(df, db)