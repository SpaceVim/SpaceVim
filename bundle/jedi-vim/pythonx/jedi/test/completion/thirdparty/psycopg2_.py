import psycopg2

conn = psycopg2.connect('dbname=test')

#? ['cursor']
conn.cursor

cur = conn.cursor()

#? ['fetchall']
cur.fetchall
