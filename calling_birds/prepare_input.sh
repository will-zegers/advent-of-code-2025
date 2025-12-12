#!/usr/bin/env bash
# Little helper script to make the input file more parsible

set -e

# TMP=$(mktemp)
# echo $TMP
# 
# tr '.' '0' < input.txt > $TMP
# tr '@' '1' < $TMP > input.txt

# We add a frame of empties around input data so we don't have to deal with edge
# cases where a pointer or index could potentially could out of bounds while
# accessing the neighbors who don't exist

# Create a row of '.' for the top and bottom row, spanning the full column width
COLUMN_COUNT=$(wc -L input.txt | cut -d\  -f1)
ZERO_ROW=$(printf "%*s\n" $(wc -L input.txt | cut -d\  -f1) | tr " " ".")

sed -i "1i $ZERO_ROW" input.txt
echo $ZERO_ROW >> input.txt

# Prepend and append each row with a '.'
sed -i 's/^/./' ./input.txt
sed -i 's/$/./' ./input.txt
