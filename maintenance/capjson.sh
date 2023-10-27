#!/bin/bash

# Function to capitalize a string while preserving specified words
capitalize_string() {
  local input="$1"
  local do_not_capitalize=("and" "or" "with" "of" "on" "in")
  words=($input)
  result=""
  for word in "${words[@]}"; do
    if [[ " ${do_not_capitalize[@]} " =~ " $word " ]]; then
      result+=" $word"
    else
      result+=" $(echo "$word" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"
    fi
  done
  result="${result# }"
  echo "$result"
}

# Function to process a JSON file
process_json_file() {
  local json_file="$1"
  local fields=("field" "subfield" "sub_subfield")

  # Iterate through the fields and apply capitalize_string function
  for thefield in "${fields[@]}"; do
    value=$(jq ".${thefield}" "$json_file")
    value="${value//\"/}"
    capvalue=$(capitalize_string "$value")
    capvalue="\"$capvalue\""
    capitalized_json=$(jq ".${thefield} |= $capvalue" "$json_file")
    echo "$capitalized_json" > "$json_file"
  done
}

# Find all .json files in folders and subfolders
find ../issues/ -type f -name "*.json" | while read -r json_file; do
  # Call the process_json_file function for each .json file
  process_json_file "$json_file"
done

