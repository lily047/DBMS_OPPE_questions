'''Write a Python program to print the ISBN numbers of books which are published in a given year. Here, the year is obtained as the value of function L(x) (given after the sample output) at x. You have to read the value of x from the input file "number.txt", and use it to find the value of L(x). Your program must assume that the file number.txt resides in the same folder as your Python program.


You have to iterate through the list and print each value separately as shown in the output below: 

9789352921171
9789351343202
9789353333380
The line function is given below:
L1(x) = 2000 + 5*x'''


import psycopg2 
import sys 
import os 

conn = psycopg2.connect(database = sys.argv[1],
                        user = os.environ.get('PGUSER'),
                        password = os.environ.get('PGPASSWORD'),
                        host = os.environ.get('PGHOST'),
                        port = os.environ.get('PGPORT'))

cursor = conn.cursor()

with open('number.txt', 'r') as f :
    input_values = f.readlines()

output_values = []
for values in input_values:
    values = values.strip('\n')
    out = 2000 + 5 * (float(values))
    output_values.append(int(out))

print(output_values)

placeholders = ','.join(["%s"]*len(output_values)) #New shit


query = f'''SELECT b.ISBN_no 
    FROM book_catalogue b 
    WHERE b.year IN ({placeholders})
    '''

cursor.execute(query, output_values)
result = cursor.fetchall()


ISBN_nos = [int(values2[0]) for values2 in result]

print(*ISBN_nos, sep = '\n')
if conn is not None:
    conn.close()
