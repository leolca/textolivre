#!/bin/bash

FILE=overleafprojectlist.csv
grep -P '^issues/[0-9]{4}/v[0-9]+/(n[0-9]+/)?[0-9]+,[a-z0-9]+$' $FILE | 
    while read line
    do
	article=$(echo $line | cut -d, -f1)
	if [ ! -d  ../$article ]
	then
	    echo $line
	fi
    done
