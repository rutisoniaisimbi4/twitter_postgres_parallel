#!/bin/bash

files=$(find data/*)

echo '======================================================='
echo 'load denormalized'
echo '======================================================='
time for file in $files; do
    python3 -u load_tweets.py \
        --db=postgresql://postgres:pass@localhost:5480/ \
        --inputs $file
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
