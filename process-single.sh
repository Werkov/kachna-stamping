#!/bin/bash
#set -x

STAMPDIR=stamps
INNER_TPL=inner-template.tex
INNER=inner.tex

FILE=$1
num=$2
name=$3

if [ "x$1" == "x" ] ; then
	echo "Usage: $0 filename.pdf num name [format]"
	echo
	echo "       Apply a stamp to 'filename', 'num' and 'name' are used"
	echo "       inside a stamp template. When format is not specified best"
	echo "       guess from dimensions is used."
	echo "       Output is written to filename-stamped.pdf"
	echo

	exit 0
elif [ "x$4" == "x" ] ; then
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

