'''In this problem, you have to write a Python program to print an encoding of the ids of the teams whose jersey colour at home is different from the jersey colour when they play away from home.


The encoding must be using a shift cipher, which is detailed below.

An alphabet is mapped to another alphabet as follows. For a given alphabet α, let pos be the position at which α occurs in the alphabet listing (A at 1, B at 2, …. Z at 26). Then the encoding of α is the alphabet at the position (pos + 7) mod 26.

For example, if M is the alphabet, then the position at which M occurs in the alphabet listing is 13. Then, the encoding of M is the alphabet at the position (13 + 7) mod 26 = 20, which is T. 

For each digit β, the encoding of β is (β+7) mod 10.

For example, if 3 is the digit, then the encoding of 3 is the number (3 + 7) mod 10 = 0.

The ids should be listed in the ascending order before performing the encoding.

Each line in the output of the program must correspond to one row retrieved from the table.'''

import psycopg2
import sys
import os 
import string 

conn = psycopg2.connect(database = sys.argv[1], user = os.environ.get('PGUSER'), password = os.environ.get('PGPASSWORD'), host = os.environ.get('PGHOST'), port = os.environ.get('PGPORT'))

cursor = conn.cursor()

def encoding_team_ids(l2:list):
    
    l = [char for char in string.ascii_uppercase]
    
    alpha_dict = {}
    reverse_alpha_dict = {}
    i=1
    for char2 in l:
        alpha_dict[char2] = i
        reverse_alpha_dict[i] = char2
        i+=1
    
    encoded_team_ids = []
    
    for items2 in l2:
        s = ''
        for char in items2:
            if char.isalpha():
                pos = alpha_dict[char]
                new_pos = (pos + 7) % 26
                s+=reverse_alpha_dict[new_pos]
            elif char.isnumeric():
                s += str((int(char) + 7)%10)
    
        encoded_team_ids.append(s)
        
    
    return encoded_team_ids


query = '''SELECT t.team_id
FROM teams t 
WHERE  t.jersey_home_color != t.jersey_away_color
ORDER BY t.team_id 
'''
cursor.execute(query)
result = cursor.fetchall()

list_of_team_ids = [items[0] for items in result ]


encoded_team_ids = encoding_team_ids(list_of_team_ids)
print(*encoded_team_ids, sep='\n')


if conn is not None:
    conn.close()

