#!/bin/bash

if [ "x$1" = "x" ] ; then
	echo "Usage: $0 filename.pdf output-file"
	echo
	echo "       Creates two files"
	echo "         - output-file contains repeated input file to fill A4"
	echo "         - output-file + nup.pdf contains repeated and laid out input file on A4"
	echo
	exit
fi

FILE=$1
OUTPUT=$2

format=`utils/get-format.sh $FILE`

num=`echo $format | sed 's/[^0-9]//g'`
rot=${format/a?-}

num=$(($num-4))
if [ $num -lt 0 ] ; then
	echo "Unsupported format ${format}, not layouting."
	cp "$FILE" "$OUTPUT"
	exit
fi

repeats=`echo "2^($num)" | bc`
w=`echo "sqrt($repeats*2)" | bc`
h=`echo "sqrt($repeats)" | bc`
if [ $(( $num % 2)) -eq 1 ] ; then
	if [ $rot == "landscape" ] ; then
		r=""
	else
		r="--landscape"
	fi
else
	if [ $rot == "landscape" ] ; then
		r="--landscape"
	else
		r=""
	fi
fi

if [ $rot == "landscape" ] ; then
	tmp=$w
	w=$h
	h=$tmp
fi

arg=""
for i in `seq $repeats` ; do
	arg="$arg $FILE"
done

pdftk $arg cat output "$OUTPUT" && \
    pdfjam --suffix nup --outfile `dirname "$OUTPUT"` --nup "${w}x${h}" $r -- "$OUTPUT"
