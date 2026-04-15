#!/bin/bash
file=$1
python3 -u load_tweets.py \
    --db=postgresql://postgres:pass@localhost:5481/ \
    --inputs $file
