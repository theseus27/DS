import mysql.connector

def create_table(db, name, fields):
    if len(fields) == 0:
        print("ERROR: Can't create table with no fields")
        return
    
    query = "CREATE TABLE " + name + "(\n"
    for field in fields:
        query += field[0] + " " + field[1] + ",\n"
    query = query[:-2] + ");"

    cursor = db.cursor()
    try:
        cursor.execute(query)
        print("Created table " + name)
    except:
        print("Failed to create table" + name)
    finally:
        cursor.close()

def drop_table(db, name):
    query = "DROP TABLE IF EXISTS " + name
    cursor = db.cursor()
    try:
        cursor.execute(query)
        print("Dropped table " + name)
    except:
        print("Failed to drop table" + name)
    finally:
        cursor.close()

def add_col(db, tablename, colname, type):
    query = "ALTER TABLE " + tablename + " ADD " + colname + type + ";"
    cursor = db.cursor()
    try:
        cursor.execute(query)
        print("Added column " + colname + " to table " + tablename)
    except:
        print("Failed to add column " + colname + " to table " + tablename) 
    finally:
        cursor.close()

def drop_col(db, tablename, colname):
    query = "ALTER TABLE " + tablename + " DROP COLUMN " + colname + ";"
    cursor = db.cursor()
    try:
        cursor.execute(query)
        print("Dropped column " + colname + " from table " + tablename)
    except:
        print("Failed to drop column " + colname + " from table " + tablename) 
    finally:
        cursor.close()

def rename_col(db, tablename, oldname, newname):
    query = "ALTER TABLE " + tablename + " RENAME COLUMN " + oldname + " to " + newname + ";"
    cursor = db.cursor()
    try:
        cursor.execute(query)
        print("Renamed column " + oldname + " to " + newname)
    except:
        print("Failed to rename " + oldname) 
    finally:
        cursor.close()

