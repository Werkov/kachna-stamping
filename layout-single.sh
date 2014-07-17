#!/bin/bash


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


pdfjam --suffix nup --nup "${w}x${h}" $r -- $REP
