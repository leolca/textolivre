#!/bin/bash

# check which published articles in current are not in overleafprojectlist.csv 

currentissue=$(curl -L --silent https://periodicos.ufmg.br/index.php/textolivre/issue/current)

vy=$(echo $currentissue | grep -Po "v. [0-9]+ \([0-9]+\): Texto Livre: Linguagem e Tecnologia" | head -n 1)
volume=$(echo $vy | grep -Po "v. [0-9]+" | tr -dc '0-9')
year=$(echo $vy | grep -Po "\([0-9]+\)" | tr -dc '0-9')
echo $currentissue | grep -P -o "e[0-9]{5}" | tr -d 'e' | sort |
    while read -r oid;
    do
	if grep -q "issues/$year/v$volume/$oid" overleafprojectlist.csv 
	then
	    ov=$(grep "issues/$year/v$volume/$oid" overleafprojectlist.csv | cut -d, -f2)
	    if [ -z $ov ] 
	    then
		echo $oid
	    fi
	else
	    echo $oid
	fi
    done

