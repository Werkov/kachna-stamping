#!/bin/bash

SAMPLE_DIR=sample-data
DST_DIR=`pwd`

if [ -f "$DST_DIR/sifry.csv" ] ; then
	echo "There is existing sifry.csv file, abort $0 not to overwrite it."
	exit
fi

cp "$SAMPLE_DIR/sifry.csv" "$DST_DIR"
cp "$SAMPLE_DIR/"*.pdf "$DST_DIR/input"

