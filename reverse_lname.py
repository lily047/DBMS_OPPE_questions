import psycopg2 
import sys 
import os 

with open('date.txt', 'r') as f:
    match_date = f.readline()


def initilising(l:list):
    if len(l) == 3 :
        fname = l[0]
        middle_name = l[1]
        lname = l[2]

        return (f'{lname} {fname[0]}. {middle_name[0]}.')
    
    elif len(l) == 2 :
        fname = l[0]
        lname = l[1]

        return (f'{lname} {fname[0]}.')
    
    else:
        return "No last name found"

conn = None 

try:
    conn = psycopg2.connect(database = sys.argv[1], 
                         user = os.environ.get('PGUSER'), 
                         password =  os.environ.get('PGPASSWORD'),,
                         host =  os.environ.get('PGHOST'), 
                         port =  os.environ.get('PGPORT'),)

    cursor = conn.cursor()

    query = '''SELECT r.name 
    FROM matches m JOIN match_referees mr ON m.match_num = mr.match_num
    JOIN referees r ON r.referee_id = mr.referee
    WHERE m.match_date = %s
    '''

    cursor.execute(query, (match_date,))

    result = str(cursor.fetchone()[0]).split(" ")

    final_result = initilising(result)

    print(final_result)


except (Exception, psycopg2.DatabaseError) as error:
    print(error)

finally:
    if conn is not None:
        conn.close()
