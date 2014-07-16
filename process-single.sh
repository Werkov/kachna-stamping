#!/bin/bash

STAMPDIR=stamps
INNER_TPL=inner-template.tex
INNER=inner.tex

FILE=$1
num=$2
name=$3

# create stamp
sed  "s/@num@/$num/g;s/@name@/$name/g" <$STAMPDIR/$INNER_TPL >$STAMPDIR/$INNER
format=`utils/get-format.sh $FILE`

cd $STAMPDIR
xelatex ${format}.tex
cd -
	
# apply stamp
pdftk "$FILE" stamp $STAMPDIR/${format}.pdf output "${FILE%.pdf}-stamped.pdf"

echo "Stamped $FILE $*"

