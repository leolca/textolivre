#!/bin/bash

# check if there were changes in overleaf (compared to local files)

# usage
# ./checkOverleaf.sh
# ./checkOverleaf.sh 37090 34141
# ./checkOverleaf.sh 37090 34141 | tee >(ansi2html | sed 's/\/tmp\/\(issues[-_a-z0-9]\+\)/<a href="\1">\1<\/a>/g' > /tmp/diff.html)

if ! command -v dwdiff &> /dev/null
then
    echo "dwdiff could not be found, please install it before running this script"
    exit
fi


NUMBERS=""
for arg in "$@"
do
    if [ -z $NUMBERS ]
    then
       NUMBERS="/$arg"
    else
       NUMBERS="$NUMBERS\|/$arg"
    fi
done

INPUT=overleafprojectlist.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
ALWAYS=false

while read FOLDER OVERLEAFID; do
  echo "Comparing $FOLDER with OverLeaf Project $OVERLEAFID"
  FOLDERreplaced=${FOLDER//\//_}
  SAVERESULT=false
  TMPFOLDER=$(mktemp -d)
  trap '{ rm -rf "$TMPFOLDER"; }' INT TERM
  until git clone -q --depth=1 https://leolca%40gmail.com@git.overleaf.com/$OVERLEAFID "$TMPFOLDER"
  do 
      echo -e "\e[1;33mFailed to clone. Waiting 5 minutes to try again...\e[0m"
      sleep 300
  done
  if [ $? -eq 0 ]
  then
     if [ -f "../$FOLDER/article.tex" ] 
     then 
        if diff -q "../$FOLDER/article.tex" "$TMPFOLDER/article.tex"; then
           echo -e "\e[1;32mTeX files are the same.\e[0m" 
        else
           echo -e "\e[1;31mTeX files are different!\e[0m"
           if [ $ALWAYS = false ]; then
              while true; do
                 read -u 2 -p "Save differences (y/n/a)?" yn
                 case $yn in
                    [Yy]* ) SAVERESULT=true; break;; 
                    [Nn]* ) SAVERESULT=false; exit;;
                    [Aa]* ) ALWAYS=true; SAVERESULT=true; break;;
                    * ) echo "Please answer yes or no.";;
                 esac
              done
           else
              SAVERESULT=true
           fi
           if [ $SAVERESULT = true ]; then
   	       OUTFILE="/tmp/$FOLDERreplaced-article-tex-diff"
	       dwdiff --no-common --line-numbers <(cat "../$FOLDER/article.tex") <(cat "$TMPFOLDER/article.tex") | colordiff --difftype=wdiff > "$OUTFILE"
	       #wdiff --no-common --avoid-wraps <(cat "../$FOLDER/article.tex") <(cat "$TMPFOLDER/article.tex") | colordiff --difftype=wdiff > "$OUTFILE"
	       #diff --color --side-by-side --suppress-common-lines <(fold -s -w72 "../$FOLDER/article.tex") <(fold -s -w72 "$TMPFOLDER/article.tex") -W 200 > "$OUTFILE"
               #diff "../$FOLDER/article.tex" "$TMPFOLDER/article.tex" > "$TMPFILE"
               echo -e "\e[1;34mDifferences saved in $OUTFILE\e[0m"
           fi
	fi
     fi
     if [ -f "../$FOLDER/article.bib" ]
     then
        if diff -q "../$FOLDER/article.bib" "$TMPFOLDER/article.bib"; then
           echo -e "\e[1;32mBiB files are the same.\e[0m" 
        else
           echo -e "\e[1;31mBiB files are different!\e[0m"
           if [ $ALWAYS = false ]; then
              while true; do
                 read -u 2 -p "Save differences (y/n/a)?" yn
                 case $yn in
                    [Yy]* ) SAVERESULT=true; break;; 
                    [Nn]* ) SAVERESULT=false; exit;;
                    [Aa]* ) ALWAYS=true; SAVERESULT=true; break;;
                    * ) echo "Please answer yes or no.";;
                 esac
              done
           else
           SAVERESULT=true
           fi
           if [ $SAVERESULT = true ]; then
   	    OUTFILE="/tmp/$FOLDERreplaced-article-bib-diff"
	    dwdiff --no-common --line-numbers <(cat "../$FOLDER/article.bib") <(cat "$TMPFOLDER/article.bib") | colordiff --difftype=wdiff > "$OUTFILE"
   	    #wdiff --no-common --avoid-wraps <(cat "../$FOLDER/article.bib") <(cat "$TMPFOLDER/article.bib") | colordiff --difftype=wdiff > "$OUTFILE"
   	    #diff --color --side-by-side --suppress-common-lines <(fold -s -w72 "$FOLDER/article.bib") <(fold -s -w72 "$TMPFOLDER/article.bib") -W 200 > "$OUTFILE"
               #diff "../$FOLDER/article.bib" "$TMPFOLDER/article.bib" > "$TMPFILE"
               echo -e "\e[1;34mDifferences saved in $OUTFILE\e[0m"
           fi  
        fi
     fi
  fi
done < <(grep -P '^issues/[0-9]{4}/v[0-9]+/(n[0-9]+/)?[0-9]+,[a-z0-9]+' $INPUT | grep "$NUMBERS")

IFS=$OLDIFS
exit 0
