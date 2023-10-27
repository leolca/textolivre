#!/bin/bash


# usage example:
# ./classify.sh 36965 
# ./classify.sh 36965 37569
# ./classify.sh `grep "/2021/" overleafprojectlist.csv | head | cut -d, -f1 | cut -d/ -f5 | tr '\n' ' '`


TL_FOLDER=$(dirname $(pwd))
IDs=( "$@" )

for (( i=0; i<${#IDs[@]}; i++ ));
do
    gresult=$(grep "/${IDs[$i]}," overleafprojectlist.csv)
    DEST_FOLDER="$TL_FOLDER/$(echo $gresult | cut -d, -f1)"
    language=$(grep -oP '^\\documentclass\[[a-z]+\]' "$DEST_FOLDER/article.tex" | grep -oP '\[[a-z]+\]' | tr -d '[]')
    if [ -z "$language" ]; then
	language="portuguese"
    fi
    if [ "$language" == "english" ]; then
	title=$(grep -P '^\\title{' "$DEST_FOLDER/article.tex" | sed 's/\\title{//g' | sed 's/"/'\''/g' | sed 's/ *}*$//')
	absenv=$(awk '/\\begin{abstract}/{c++; if (c == 1) p = 1} p; /\\end{abstract}/{p = 0}' "$DEST_FOLDER/article.tex")
    elif [ "$language" != "portuguese" ]; then
	title=$(grep -P '^\\othertitle{' "$DEST_FOLDER/article.tex" | head -n 2 | tail -n 1 | sed 's/\\othertitle{//g' | sed 's/"/'\''/g' | sed 's/ *}*$//')
	absenv=$(awk '/\\begin{abstract}/{c++; if (c == 3) p = 1} p; /\\end{abstract}/{p = 0}' "$DEST_FOLDER/article.tex")
    else # portuguese
	title=$(grep -P '^\\othertitle{' "$DEST_FOLDER/article.tex" | head -n 1 | sed 's/\\othertitle{//g' | sed 's/"/'\''/g' | sed 's/ *}*$//')
	absenv=$(awk '/\\begin{abstract}/{c++; if (c == 2) p = 1} p; /\\end{abstract}/{p = 0}' "$DEST_FOLDER/article.tex")
    fi
    if [ -z "$title" ]; then
	title=$(grep -P '^\\title{' "$DEST_FOLDER/article.tex" | head -n 1 | sed 's/\\title{//g' | sed 's/"/'\''/g' | sed 's/ *}*$//')
    fi
    abstract=$(echo "$absenv" | grep -vE '\\begin{abstract}|\\end{abstract}|\keywords{.*}' | detex | sed 's/"/'\''/g' | tr '\n' ' ' | ./convert_latex_to_unicode.awk)
    keywords=$(echo "$absenv" | grep '\keywords{.*}' | sed 's/\\keywords{//g' | sed 's/ *}*$//' | sed 's/ *\\sep */, /g' | ./convert_latex_to_unicode.awk)
    authors=$(grep -oP '^\\author\[\d+\]\{\K[^\\]+' "$DEST_FOLDER/article.tex" | sed 's/ *$//g' | sed 's/~$//g')
    orcids=$(grep -P '^\\author\[\d+\]\{\K[^\\]+' "$DEST_FOLDER/article.tex" | grep -oP '\\orcid\{\K[^}]+')
    emails=$(grep -P '^\\author\[\d+\]\{\K[^\\]+' "$DEST_FOLDER/article.tex" | grep -Po 'Email: \\url{[^}]+}|\\href{mailto:[^}]+}' | sed 's/Email: \\url{//g' | sed 's/\\href{mailto://g' | sed 's/\\_/_/g' | sed 's/}$//g' | sed 's/ *}*$//')
    pub_date=$(grep -oP '^\\publisheddate\{\\DTMdisplaydate\{\d+\}{\d+}{\d+}{-\d+\}\}' "$DEST_FOLDER/article.tex" | sed 's/\\publisheddate{\\DTMdisplaydate{//g' | sed 's/}{-1}}//g' | sed 's/}{/-/g')
    if [ -n "${abstract// }" ]; then
	json_result=$(python openai-classify.py "$abstract")
    fi
    # Extract the values for Field, Subfield, and Sub-subfield using jq
    content=$(echo "$json_result" | jq -r .content)
    field=$(echo "$content" | grep -o 'Field: [^;]*' | cut -d ' ' -f 2-)
    subfield=$(echo "$content" | grep -o 'Subfield: [^;]*' | cut -d ' ' -f 2-)
    sub_subfield=$(echo "$content" | grep -o 'Sub-subfield: [^;]*' | cut -d ' ' -f 2- | sed 's/\.$//g')
    readarray -t arr_authors <<<"$authors"
    readarray -t arr_orcids <<<"$orcids"
    readarray -t arr_emails <<<"$emails"
    # Construct the JSON structure
    json="{\"title\":\"$title\",\"language\":\"$language\",\"abstract\":\"$abstract\",\"keywords\":\"$keywords\",\"authors\":["
    for j in "${!arr_authors[@]}"; do
	json+="{
	\"name\":\"${arr_authors[j]}\",
        \"orcid\":\"${arr_orcids[j]}\",
        \"email\":\"${arr_emails[j]}\"
        }"
        # Add a comma if it's not the last author
        if [ $j -lt $(( ${#arr_authors[@]} - 1 )) ]; then
            json+=","
        fi
    done
    json+="],\"publication_date\":\"$pub_date\",\"field\":\"$field\",\"subfield\":\"$subfield\",\"sub_subfield\":\"$sub_subfield\"}"
    # Save the JSON string to a file
    echo "$json" > "$DEST_FOLDER/article.json"
    echo "JSON file $DEST_FOLDER/article.json created"
    if cat "$DEST_FOLDER/article.json" | jq . > /dev/null; then
	echo "JSON validation succeeded."
    else
        echo "JSON validation failed."
    fi
done
