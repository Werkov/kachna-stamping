#!/bin/bash

FILE="$1"

pdfinfo "$FILE" | awk '/Page size/ { print $3, $5 }' >tmp
read width height <tmp
rm tmp

if [ `echo "$width < $height" | bc` = 1  ] ; then
	rot="portrait"
	lesser=$width
else
	rot="landscape"
	lesser=$height
fi

# a0size = 2383.8 pts
# epsilon = 20 pts (7mm)

a0size=2363.8 # points
i=0
while [ `echo "$lesser < $a0size" | bc` = 1 ] ; do
	lesser=`echo "$lesser * 1.4142" | bc`
	i=$(($i + 1))
done

echo "a$i-$rot"
