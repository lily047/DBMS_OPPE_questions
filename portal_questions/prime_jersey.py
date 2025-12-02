'''In this question, you have to write a Python program to print the names of the players and the team of each player of all those players whose jersey number is a prime number. 

The list should be ordered in reverse alphabetical order of player names. If two or more players have the same name, then further sorting should be done on the team name, again in reverse alphabetical order.

The format of output is as given below:

Name of the player, followed by a comma (,), then a space and then the team name.


For example, if Arjun has jersey number 5 and is playing for All Stars and Pranav, with jersey number 7, is playing for team Amigos, then the output will be:

Pranav, Amigos

Arjun, All Stars'''

import psycopg2
import sys 
import os 

conn = None 

try:
  conn = psycopg2.connect(database = sys.argv[1], user = os.environ.get('PGUSER'), password = os.environ.get('PGPASSWORD'), host = os.environ.get('PGHOST'), port = os.environ.get('PGPORT'))
  
  
  cursor = conn.cursor()
  
  def is_prime(n):
      if n<2:
          return False
      for i in range(2, (int(int(n)**(1/2)+1))):
          if n%i==0:
              return 0
          
      return n
  
  
  
  query1 =''' SELECT p.name, t.name, p.jersey_no
  FROM players p JOIN teams t ON p.team_id = t.team_id 
  ORDER BY p.name DESC
  '''
  cursor.execute(query1)
  result = cursor.fetchall()
  
  
  for name, team, jersey_no in result:
      if is_prime(jersey_no):
          print(f'{name}, {team}')
except (Exception, psycopg2.DatabaseError) as error:
  print(error)

finally:

  if conn is not None:
      conn.close() 

