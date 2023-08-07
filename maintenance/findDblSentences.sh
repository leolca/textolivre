#!/bin/bash

# Check if file argument is provided
if [ -z "$1" ]; then
  echo "Please provide the path to a text file."
  exit 1
fi

# Extract the file extension
extension="${1##*.}"

# Convert based on the file extension
case "$extension" in
  txt)
    # No conversion needed, it's already a text file
    echo "Input file is already a text file."
    ;;
  pdf)
    # Convert PDF to text using pdftotext
    pdftotext "$1" "${1%.*}.txt"
    echo "PDF converted to text."
    ;;
  tex)
    # Convert LaTeX to text using pandoc
    pandoc -s "$1" -t plain -o "${1%.*}.txt"
    echo "LaTeX converted to text."
    ;;
  *)
    echo "Unsupported file extension: $extension"
    exit 1
    ;;
esac

# Preprocess the text by removing line breaks within paragraphs and inserting line breaks after punctuation
preprocessed_file="$(mktemp)"
trap "rm -rf $preprocessed_file" err exit
cat "${1%.*}.txt" | tr '\n' ' ' | sed 's/\([.!?]\)/\1\n/g' | tr -s ' ' | awk '{$1=$1};1' | sed 's/\([^A-Za-zÀ-Ö,;]\) \([A-Z]\)/\1\n\2/g' > "$preprocessed_file"

# Detect repeating sentences using awk
sort "$preprocessed_file" | uniq -c | sort -rn | awk '$1 > 1'

# Clean up temporary text file
if [[ "$1" == *.pdf || "$1" == *.tex ]]; then
  rm "${1%.*}.txt"
fi

