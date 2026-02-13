#!/usr/bin/env bash
# Little helper script to make the input file more parsible

set -e

INPUT_FILE=input.txt
PREPARED_INPUT_FILE=${1:-${INPUT_FILE}}
if [[ ${INPUT_FILE} != ${PREPARED_INPUT_FILE} ]]; then
  cp ${INPUT_FILE} ${PREPARED_INPUT_FILE}
fi

# We add a frame of empties around input data so we don't have to deal with edge
# cases where a pointer or index could potentially go out of bounds while
# accessing the neighbors who don't exist

# Create a row of '.' for the top and bottom row, spanning the full column width
COLUMN_COUNT=$(wc -L input.txt | cut -d\  -f1)
ZERO_ROW=$(printf "%*s\n" $COLUMN_COUNT | tr " " ".")

sed -i "1i $ZERO_ROW" ${PREPARED_INPUT_FILE}
echo $ZERO_ROW >> ${PREPARED_INPUT_FILE}

# Prepend and append each row with a '.'
sed -i 's/^/./' ${PREPARED_INPUT_FILE}
sed -i 's/$/./' ${PREPARED_INPUT_FILE}
