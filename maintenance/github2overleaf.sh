#!/bin/bash

# usage example:
# ./github2overleaf.sh 36965 37426 37557 37569

IDs=( "$@" )
CURRENTFOLDER=$(pwd)
TL_FOLDER=$(dirname $CURRENTFOLDER)
for (( i=0; i<${#IDs[@]}; i++ ));
do
    echo "${IDs[$i]}"
    gresult=$(grep "${IDs[$i]}" overleafprojectlist.csv)
    SOURCE_FOLDER="$TL_FOLDER/$(echo $gresult | cut -d, -f1)"
    OVERLEAFID=$(echo $gresult | cut -d, -f2)
    if [ ! -z $SOURCE_FOLDER ] && [ ! -z $OVERLEAFID ]
    then
	TMPFOLDER=$(mktemp -d)
	trap '{ rm -rf "$TMPFOLDER"; }' INT TERM
	until git clone -q --depth=1 https://leolca%40gmail.com@git.overleaf.com/$OVERLEAFID "$TMPFOLDER"
	do
	    echo -e "\e[1;33mFailed to clone. Waiting 5 minutes to try again...\e[0m"
	    sleep 300
	done
	if [ $? -eq 0 ]
	then
	    cd $TMPFOLDER
	    diff -q . "$SOURCE_FOLDER" | grep "differ" | sed 's/^Files[^/]//g' | sed 's/ and.*//g' | cut -d/ -f2 | 
		while read -r FILE 
		do
		    cp "$SOURCE_FOLDER/$FILE" . 
		    git add $FILE
		done
	    git commit -m 'updating files from github'
	    git push origin master
	    cd $CURRENTFOLDER 
	    rm -rf "$TMPFOLDER"
	fi
    fi
done
