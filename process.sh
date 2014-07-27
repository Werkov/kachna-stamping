#!/bin/bash
#set -x

# Usage: process.sh CSV-file
INPUT_DIR=final
DATA=$1
PROC=./process-single.sh

export IFS=";"
cat $DATA | while read id num variant format ; do
	FILE=`echo $INPUT_DIR/$id-*.pdf`
	CHECK="$INPUT_DIR/$id-*.pdf"
	#;FILE=`echo $INPUT_DIR/2014-kachna-fake-$id-v1.pdf`
	#CHECK="$INPUT_DIR/2014-kachna-fake-$id-v1_.pdf"

	if [ "$FILE" == "$CHECK" ] ; then
		echo "Invalid team ID '$id' or missing puzzle."
		continue
	fi

	if [ "x$format" == "x" ] ; then
		$PROC $FILE $num $variant
	else
		$PROC $FILE $num $variant $format
	fi
done
