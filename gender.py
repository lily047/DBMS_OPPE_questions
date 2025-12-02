'''Write a Python program that reads a student's first name from a file named name.txt (in the
same folder as the program), retrieves the student's gender, and prints MALE if the gender is
M or FEMALE if the gender is F .
For example, if the first name of the student is 'Vikas' and the gender is 'M'. Then output
must be MALE only. Note: No spaces.
For example, if the first name of the student is 'Rita' and the gender is 'F'. Then output must
be FEMALE only. Note: No spaces.'''

import psycopg2 
import sys 
import os 

conn = psycopg2.connect(database = sys.argv[1], 
                        user = os.environ.get('PGUSER'), 
                        password = os.environ.get('PGPASSWORD'), 
                        host = os.environ.get("PGHOST"), 
                        port = os.environ.get("PGPORT"))

cursor = conn.cursor()

with open('name.txt', 'r') as f:
    student_name = f.readline()



query = '''SELECT s.gender
FROM students s 
WHERE student_fname = %s
'''
cursor.execute(query, (student_name,))

result = cursor.fetchone()


if result[0] == 'M':
    print('MALE')
else:
    print('FEMALE')

if conn is not None:
    conn.close()
