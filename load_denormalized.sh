#!/bin/bash
file=$1
echo $file
unzip -p "$file" | python3 -c "
import sys, psycopg2
conn = psycopg2.connect('postgresql://postgres:pass@localhost:5480/')
conn.autocommit = True
cur = conn.cursor()
for line in sys.stdin:
    cur.execute('INSERT INTO tweets_jsonb(data) VALUES (%s)', (line.strip(),))
conn.close()
"
