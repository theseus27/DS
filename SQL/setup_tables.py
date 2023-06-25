from db import connect

def exec(db, description, query):
    db.reconnect()
    cursor = db.cursor()
    try:
        cursor.execute(query)
        db.commit()
        print(description)
    except:
        print("FAILED " + description) 
    finally:
        cursor.close()
        pass

def setup_pokemon():
    db = connect('pokemondb')

    # DELETE TABLES
    exec(db, "Delete tables", "DROP TABLE IF EXISTS pokemon; DROP TABLE IF EXISTS types; DROP TABLE IF EXISTS type_advantages;")

    # CREATE pokemon
    query = """
        CREATE TABLE pokemon (
            PokemonID int NOT NULL,
            PokemonName varchar(255) NOT NULL,
            TypeOne varchar(20) NOT NULL,
            TypeTwo varchar(20),
            EvolvesTo int,
            EvolvesFrom int,
            PRIMARY KEY (PokemonID),
            FOREIGN KEY (EvolvesTo) REFERENCES pokemon(PokemonID),
            FOREIGN KEY (EvolvesFrom) REFERENCES pokemon(PokemonID)
        )
        """
    exec(db, "Create pokemon table", query)

    # CREATE types
    query = """
        CREATE TABLE types (
            TypeName varchar(255) NOT NULL,
            PRIMARY KEY (TypeName)
        )
        """
    exec(db, "Create types table", query)

    # CREATE type_advantages
    query = """
        CREATE TABLE type_advantages(
            TypeAdvID int NOT NULL,
            stronger varchar(255) NOT NULL,
            weaker varchar(255) NOT NULL,
            PRIMARY KEY (TypeAdvID),
            FOREIGN KEY (stronger) REFERENCES types(TypeName),
            FOREIGN KEY (weaker) REFERENCES types(TypeName)
        )
    """
    exec(db, "Create type advantage table", query)


    db.close()

def setup_cards():
    db = connect('pokemondb')

    # DELETE TABLES
    exec(db, "Delete tables", "DROP TABLE IF EXISTS cards; DROP TABLE IF EXISTS expansions;")

    # CREATE expansions
    query = """
        CREATE TABLE expansions (
            ExpansionID varchar(255) NOT NULL,
            ExpansionName varchar(255) NOT NULL,
            ReleaseDate DATE,
            Series varchar(255),
            NormalTotal int NOT NULL,
            FullTotal int NOT NULL,
            PRIMARY KEY (ExpansionID)
        )
    """
    exec(db, "Create expansion table", query)

    # CREATE cards
    query = """
        CREATE TABLE cards (
            CardID varchar(255) NOT NULL,
            CardName varchar(255) NOT NULL,
            CardType varchar(255) NOT NULL,
            Rarity varchar(255) NOT NULL,
            PokemonType varchar(255),
            PokemonName varchar(255),
            HP int,
            TrainerType varchar(255),
            Expansion varchar(255) NOT NULL,
            SetNumber int NOT NULL,

            PRIMARY KEY (CardID),
            FOREIGN KEY (PokemonType) REFERENCES types(TypeName),
            FOREIGN KEY (Expansion) REFERENCES expansions(ExpansionID)
        )
        """
    exec(db, "Create card table", query)

    return db