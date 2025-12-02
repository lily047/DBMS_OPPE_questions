'''Problem Statement:-
Write a Python program that reads a student's first name from a file named name.txt
(located in the same folder as the Python program). The program should then find the
student's date of birth and calculate the sum of all digits in that date.
Example 1:
First name: Vikas
Date of Birth: 2002-05-09
Calculation: 2 + 0 + 0 + 2 + 0 + 5 + 0 + 9 = 18
Output: 18
Example 2:
First name: Abdul
Date of Birth: 2003-04-21
Calculation: 2 + 0 + 0 + 3 + 0 + 4 + 2 + 1 = 12
Output: 12
Note: Only the digits in the date of birth are considered for summation.'''


import psycopg2
import sys 
import os 

with open('name.txt', 'r') as f:
    student_fname = f.readline()

conn = None

try:
    conn = psycopg2.connect(database = sys.argv[1], 
                            user = os.environ.get('PGUSER'), 
                            password = os.environ.get('PGPASSWORD'), 
                            host = os.environ.get('PGHOST'), 
                            port = os.environ.get('PGPORT'))
    
    cursor  = conn.cursor()

    query = '''SELECT s.dob
    FROM students s 
    WHERE s.student_fname = %s
    '''
    cursor.execute(query, (student_fname,))

    result = str(cursor.fetchone()[0])

    
    sum_of_digits = 0

    for char in result:
        if char != '-':
            sum_of_digits += int(char)
        
    print(sum_of_digits)
    
except (Exception, psycopg2.DatabaseError) as error:
    print(error)

finally:
    if conn is not None:
        conn.close()
