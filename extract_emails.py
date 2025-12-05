'''Write a Python program to print the email id of user whose user id is given in the file name d 'id.txt', which resides in the same folder as python program file.
The output of the python program is email of user only.
For example, if the user id (user
id) is 'U0001'
Then output must be
RUBY@gmail.com only'''

import psycopg2 
import sys 
import os 

with open('parameter.txt', 'r') as f:
    id = f.readline()

conn = None

try:
    conn = psycopg2.connect(database = sys.argv[1], 
                         user = os.environ.get('PGUSER'), 
                         password =  os.environ.get('PGPASSWORD'),,
                         host =  os.environ.get('PGHOST'), 
                         port =  os.environ.get('PGPORT'),)

    cursor = conn.cursor()

    query = '''SELECT email 
    FROM users 
    WHERE user_id = %s
    '''

    cursor.execute(query, (id,))

    results = cursor.fetchone()

    print(results[0])

except (Exception, psycopg2.DatabaseError) as error:
    print(error)

finally:
    if conn is not None:
        conn.close()
