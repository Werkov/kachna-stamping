#!/bin/bash

if [ "x$1" = "x" ] ; then
	echo "Usage: $0 filename.pdf"
	echo
	echo "       Creates two files"
	echo "         - filename-rep.pdf contains repeated input file to fill A4"
	echo "         - filename-rep-nup.pdf contains repeated and laid out input file on A4"
	echo
fi

FILE=$1

format=`utils/get-format.sh $FILE`

num=`echo $format | sed 's/[^0-9]//g'`
rot=${format/a?-}

num=$(($num-4))
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

REP=${FILE%.pdf}-rep.pdf
pdftk $arg cat output $REP

r="--landscape"

pdfjam --suffix nup --nup "${w}x${h}" $r -- $REP
