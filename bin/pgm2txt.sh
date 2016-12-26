#!/bin/bash

DBDIR="./db.$1"
if [ ! -d $DBDIR ]; then
	mkdir $DBDIR
fi

GOCR_OPTS="-a 100 -m 2 -m 8 -m 16 -m 64 -m 130"

for FILE in $1*.pgm; do
	gocr $GOCR_OPTS -p "$DBDIR/" -i $FILE -o ${FILE/.pgm/.txt}
done
