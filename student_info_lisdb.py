'''Write a Python program to print the first name, last name, and the respective year
of birth.

If the year is even, print "EvenYear"; otherwise, print "OddYear".

For the student whose roll number is specified in the file named id.txt (located in the same
folder as the Python program).

The output of the Python program should include only the first letter of last name,
then full stop, then first name and the year of birth.

If the year is even, append
"EvenYear"; otherwise, append "OddYear"

For example:
If the first name is "Vikas," the last name is "Das" and the date of birth is '2002-05-09', the year of birth is 2002, which is even.

The final output should be
D.Vikas,EvenYear (no spaces).

If the first name is "Sita" the last name is "Nayak" and the date of birth is
'2003-12-30', the year of birth is 2003, which is odd.

The final output should be
N.Sita,OddYear (no spaces).'''

import psycopg2 
import sys 
import os 

with open('roll_no.txt', 'r')as f :
    roll_no = f.readline()

conn = None 

try:
    conn = psycopg2.connect(database = sys.argv[1], 
                         user = os.environ.get('PGUSER'), 
                         password =  os.environ.get('PGPASSWORD'),,
                         host =  os.environ.get('PGHOST'), 
                         port =  os.environ.get('PGPORT'),)

    cursor = conn.cursor()

    query = '''SELECT student_fname, student_lname, dob
    FROM students 
    WHERE roll_no = %s
    '''
    cursor.execute(query, (roll_no,))

    results = cursor.fetchone()
    

    fname = results[0]
    

    lname = results[1]
    

    date = str(results[2])
    

    def is_date_even_or_odd(s:str):
        l = s.split('-')
        l_year = l[0]
        if int(l_year)%2 == 0:
            return f'EvenYear'
        else:
            return f'OddYear'
        
    print(f"{lname[0]}.{fname},{is_date_even_or_odd(date)}")

except (Exception, psycopg2.DatabaseError) as error:
    print(error)

finally:
    if conn is not None:
        conn.close()
