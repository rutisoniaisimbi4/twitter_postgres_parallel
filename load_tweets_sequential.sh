#!/bin/bash

files=$(find data/*)

echo '======================================================='
echo 'load denormalized'
echo '======================================================='
time for file in $files; do
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
done

echo '======================================================='
echo 'load pg_normalized'
echo '======================================================='
time for file in $files; do
    python3 -u load_tweets.py \
        --db=postgresql://postgres:pass@localhost:5481/ \
        --inputs $file
done

echo '======================================================='
echo 'load pg_normalized_batch'
echo '======================================================='
time for file in $files; do
    python3 -u load_tweets_batch.py \
        --db=postgresql://postgres:pass@localhost:5482/ \
        --inputs $file
done
