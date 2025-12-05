'''Write a Python program to find the faculty's first name, last name and the
respective date of joining (doj).
faculty id is given in a file named 'id.txt' resides in the same folder as python
program file.
The output of the python program must be in following manner:
For example,
'Sanchit'
,
' Jain' and 2017-01-02 is the first name, last name and doj of
facutly id FCS01. Then, the final output must be J.Sanchit02012017 only.
Note: No spaces.
For example,
'Sumanta'
,
'Kuiley' and 2016-01-03 is the first name, last name and doj
of facutly id FCS02. Then, the final output must be K.Sumanta03012016 only.'''


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

  query = '''SELECT faculty_fname, faculty_lname, doj
  FROM faculty 
  WHERE id = %s
  '''
  cursor.execute(query, (id,))

  results = cursor.fetchall()

  fname = results[0][0]

  lname_initial = results[0][1][0]

  date = str(results[0][2])

  def date_format(s:str):
    l = s.split("-")
    l_year = l[0]
    l_month = l[1]
    l_date = l[2]

    formatted_date = "".join((l_date,l_month,l_year))

    return formatted_date
  
  final_date = date_format(date)

  print(f'{lname_initial}.{fname}{final_date}')

  
except(Exception, psycopg2.DatabaseError) as error:
  print(error)

finally:
  if conn is not None:
    conn.close()
