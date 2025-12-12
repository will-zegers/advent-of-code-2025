#!/usr/bin/env bash
# Little helper script to make the input file more parsible

set -e

STAMP_FILE="input_ready.stamp"

if [ -f $STAMP_FILE ]; then
  echo "'input.txt' has already been prepared. No action needed"
  exit 0
fi

# We add a frame of empties around input data so we don't have to deal with edge
# cases where a pointer or index could potentially could out of bounds while
# accessing the neighbors who don't exist

# Create a row of '.' for the top and bottom row, spanning the full column width
COLUMN_COUNT=$(wc -L input.txt | cut -d\  -f1)
ZERO_ROW=$(printf "%*s\n" $COLUMN_COUNT | tr " " ".")

sed -i "1i $ZERO_ROW" input.txt
echo $ZERO_ROW >> input.txt

# Prepend and append each row with a '.'
sed -i 's/^/./' ./input.txt
sed -i 's/$/./' ./input.txt

touch $STAMP_FILE
