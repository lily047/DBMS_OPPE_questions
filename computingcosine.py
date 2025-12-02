'''In this question, you must write a Python program to find the cosine of a number obtained from performing a computation on a value retrieved from the database. 

Find the sum of scores of all host teams satisfying the following conditions.

host_team_score > guest_team_score

name of the host team starts with the character given in the input file ‘parameter.txt’. You have to read the character from the file and use it in your query to retrieve the expected sum. Your program must assume that parameter.txt resides in the same folder as your Python program. 

Let this sum be denoted by ‘S’. Compute X = S * 10. 

Assuming that X is a value in radians, convert it into degrees. That is, let X_deg = X * (pi/180).

Then, using the math library in Python, find cos(X_deg) correct up to two decimal places, where cos denotes the mathematical trigonometric function cosine.

For example, if the sum of scores of all host teams satisfying the given conditions is 5, then the output is round(cos(5*10*(pi/180)),2).'''

import psycopg2
import sys 
import os 
import math as math

conn = psycopg2.connect(database = sys.argv[1], 
                        user = os.environ.get('PGUSER'), 
                        password = os.environ.get('PGPASSWORD'), 
                        host = os.environ.get('PGHOST'), 
                        port = os.environ.get('PGPORT'))

cursor = conn.cursor()

with open('parameter.txt', 'r') as f:
    character = f.readline()

print(character)

query = '''SELECT SUM(m.host_team_score)
FROM matches m JOIN teams t ON t.team_id = m.host_team_id 
WHERE m.host_team_score > guest_team_score AND t.name Like %s
'''

cursor.execute(query, (character + '%',))
result = cursor.fetchone()
 
S = result[0]


X = S *10 


X_deg = X * (math.pi/180)


cos_X = math.cos(X_deg)


print(round(cos_X, 2))

if conn is not None:
    conn.close()
