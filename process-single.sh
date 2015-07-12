#!/bin/bash
#set -x

STAMPDIR=stamps
INNER_TPL=inner-template.tex
INNER=inner.tex

FILE=$1
OUTPUT=$2
num=$3
name=$4

if [ "x$1" == "x" ] ; then
	echo "Usage: $0 filename.pdf output-name num name [format]"
	echo
	echo "       Apply a stamp to 'filename', 'num' and 'name' are used"
	echo "       inside a stamp template. When format is not specified best"
	echo "       guess from dimensions is used."
	echo "       Output is written to output-name file."
	echo

	exit 0
elif [ "x$5" == "x" ] ; then
	format=`utils/get-format.sh $FILE`
else
	format=$5
fi

if [ ! -f "$STAMPDIR/${format}.tex" ] ; then
	format=unknown
fi

# create stamp
sed  "s/@num@/$num/g;s/@name@/$name/g" <$STAMPDIR/$INNER_TPL >$STAMPDIR/$INNER
cd $STAMPDIR
xelatex ${format}.tex
cd -
	
# apply stamp
pdftk "$FILE" stamp $STAMPDIR/${format}.pdf output "$OUTPUT"

echo "Stamped $FILE $*"

