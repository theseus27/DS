# pip install mysql-connector-python

import mysql.connector
import os
import dotenv

def connect(dbname):
    dotenv.load_dotenv()
    db = mysql.connector.connect(user='Theseus', password=os.getenv('SQL_PW'),
                                        host='127.0.0.1', database=dbname)
    if not db.is_connected():
        print("Error connecting to SQL")
        return
    else:
        print("Connected to db " + dbname)
        return db
    
def post(db, cmd):
    cursor = db.cursor()
    result = cursor.execute(cmd)

def get(db, cmd):
    cursor = db.cursor()
    cursor.execute(cmd)

    results = []
    for item in cursor:
        results.append(item)
    
    cursor.close()
    return results