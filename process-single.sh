#!/bin/bash

STAMPDIR=stamps
INNER_TPL=inner-template.tex
INNER=inner.tex

FILE=$1
num=$2
name=$3

if [ "x$4" =="x" ] ; then
	format=`utils/get-format.sh $FILE`
else
	format=$4
fi

# create stamp
sed  "s/@num@/$num/g;s/@name@/$name/g" <$STAMPDIR/$INNER_TPL >$STAMPDIR/$INNER
cd $STAMPDIR
xelatex ${format}.tex
cd -
	
# apply stamp
pdftk "$FILE" stamp $STAMPDIR/${format}.pdf output "${FILE%.pdf}-stamped.pdf"

echo "Stamped $FILE $*"

