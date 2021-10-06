#!/bin/bash

INPUT=overleafprojectlist.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
ALWAYS=false

while read FOLDER OVERLEAFID; do
  echo "Comparing $FOLDER with OverLeaf Project $OVERLEAFID"
  SAVERESULT=false
  TMPFOLDER=$(mktemp -d)
  trap '{ rm -f "$TMPFOLDER"; }' SIGINT SIGTERM
  git clone -q --depth=1 https://leolca%40gmail.com@git.overleaf.com/$OVERLEAFID "$TMPFOLDER"
  if diff -q "$FOLDER/article.tex" "$TMPFOLDER/article.tex"; then
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
        TMPFILE=$(mktemp)
        diff "$FOLDER/article.tex" "$TMPFOLDER/article.tex" > "$TMPFILE"
        echo -e "\e[1;34mDifference saved in $TMPFILE\e[0m"
     fi  
  fi
  if diff -q "$FOLDER/article.bib" "$TMPFOLDER/article.bib"; then
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
        TMPFILE=$(mktemp)
        diff "$FOLDER/article.bib" "$TMPFOLDER/article.bib" > "$TMPFILE"
        echo -e "\e[1;34mDifference saved in $TMPFILE\e[0m"
     fi  
  fi
  rm -rf "$TMPFOLDER"
done < <(grep -P '^issues/[0-9]{4}/v[0-9]+/n[0-9]+/[0-9]+,[a-z0-9]+' $INPUT)

IFS=$OLDIFS
exit 0
