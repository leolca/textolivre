#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

input_bib_file="$1"
temp_file=$(mktemp)
# Trap to remove the temporary directory on script exit
trap 'rm -rf "$temp_file"' EXIT

# Define the replacements
sed -E \
    -e "s/(\`a)|(\`\{a\})|(\{\`a\})|(\{\`\{a\}\})/à/g" \
    -e "s/(\`A)|(\`\{A\})|(\{\`A\})|(\{\`\{A\}\})/À/g" \
    -e "s/(\\\'a)|(\\\'\{a\})|(\{\\\'a\})|(\{\\\'\{a\}\})/á/g" \
    -e "s/(\\\'A)|(\\\'\{A\})|(\{\\\'A\})|(\{\\\'\{A\}\})/Á/g" \
    -e "s/(\\\~a)|(\\\~\{a\})|(\{\\\~a\})|(\{\\\~\{a\}\})/ã/g" \
    -e "s/(\\\~A)|(\\\~\{A\})|(\{\\\~A\})|(\{\\\~\{A\}\})/Ã/g" \
    -e "s/(\\\\\^a)|(\\\\\^\{a\})|(\{\\\\\^a\})|(\{\\\\\^\{a\}\})/â/g" \
    -e "s/(\\\\\^A)|(\\\\\^\{A\})|(\{\\\\\^A\})|(\{\\\\\^\{A\}\})/Â/g" \
    -e "s/(\`e)|(\`\{e\})|(\{\`e\})|(\{\`\{e\}\})/è/g" \
    -e "s/(\`E)|(\`\{E\})|(\{\`E\})|(\{\`\{E\}\})/È/g" \
    -e "s/(\\\'e)|(\\\'\{e\})|(\{\\\'e\})|(\{\\\'\{e\}\})/é/g" \
    -e "s/(\\\'E)|(\\\'\{E\})|(\{\\\'E\})|(\{\\\'\{E\}\})/É/g" \
    -e "s/(\\\\\^e)|(\\\\\^\{e\})|(\{\\\\\^e\})|(\{\\\\\^\{e\}\})/ê/g" \
    -e "s/(\\\\\^E)|(\\\\\^\{E\})|(\{\\\\\^E\})|(\{\\\\\^\{E\}\})/Ê/g" \
    -e "s/(\`i)|(\`\{i\})|(\{\`i\})|(\{\`\{i\}\})/ì/g" \
    -e "s/(\`I)|(\`\{I\})|(\{\`I\})|(\{\`\{I\}\})/Ì/g" \
    -e "s/(\\\'i)|(\\\'\{i\})|(\{\\\'i\})|(\{\\\'\{i\}\})/í/g" \
    -e "s/(\\\'I)|(\\\'\{I\})|(\{\\\'I\})|(\{\\\'\{I\}\})/Í/g" \
    -e "s/(\\\'\\\i)|(\\\'\{\\\i\})|(\{\\\'\\\i\})|(\{\\\'\{\\\i\}\})/í/g" \
    -e "s/(\\\'\\\I)|(\\\'\{\\\I\})|(\{\\\'\\\I\})|(\{\\\'\{\\\I\}\})/Í/g" \
    -e "s/(\`o)|(\`\{o\})|(\{\`o\})|(\{\`\{o\}\})/ò/g" \
    -e "s/(\`O)|(\`\{O\})|(\{\`O\})|(\{\`\{O\}\})/Ò/g" \
    -e "s/(\\\'o)|(\\\'\{o\})|(\{\\\'o\})|(\{\\\'\{o\}\})/ó/g" \
    -e "s/(\\\'O)|(\\\'\{O\})|(\{\\\'O\})|(\{\\\'\{O\}\})/Ó/g" \
    -e "s/(\\\~o)|(\\\~\{o\})|(\{\\\~o\})|(\{\\\~\{o\}\})/õ/g" \
    -e "s/(\\\~O)|(\\\~\{O\})|(\{\\\~O\})|(\{\\\~\{O\}\})/Õ/g" \
    -e "s/(\\\\\^o)|(\\\\\^\{o\})|(\{\\\\\^o\})|(\{\\\\\^\{o\}\})/ô/g" \
    -e "s/(\\\\\^O)|(\\\\\^\{O\})|(\{\\\\\^O\})|(\{\\\\\^\{O\}\})/Ô/g" \
    -e "s/(\`u)|(\`\{u\})|(\{\`u\})|(\{\`\{u\}\})/ù/g" \
    -e "s/(\`U)|(\`\{U\})|(\{\`U\})|(\{\`\{U\}\})/Ù/g" \
    -e "s/(\\\'u)|(\\\'\{u\})|(\{\\\'u\})|(\{\\\'\{u\}\})/ú/g" \
    -e "s/(\\\'U)|(\\\'\{U\})|(\{\\\'U\})|(\{\\\'\{U\}\})/Ú/g" \
    -e "s/(\\\~n)|(\\\~\{n\})|(\{\\\~n\})|(\{\\\~\{n\}\})/ñ/g" \
    -e "s/(\\\~N)|(\\\~\{N\})|(\{\\\~N\})|(\{\\\~\{N\}\})/Ñ/g" \
    -e "s/(\\\c\{c\})|(\{\\\c\{c\}\})/ç/g" \
    -e "s/(\\\c\{C\})|(\{\\\c\{C\}\})/Ç/g" \
    "$input_bib_file" > "$temp_file"

if diff -q "$temp_file" "$input_bib_file" > /dev/null; then
    echo "No changes in bib file."
else
    echo -e "Changes were made. ${YELLOW}Check the differences.${NC}"
    meld "$temp_file" "$input_bib_file"
    while true; do
	echo -e -n "Do you want to ${YELLOW}replace${NC} the file? (Y/N): "
	read choice
	case "$choice" in
	    [Yy])
		cp "$temp_file" "$input_bib_file"
		echo "Replacing the file..."
		if ! diff -q "$temp_file" "$input_bib_file" > /dev/null; then
		    "Files still differ!"
		    exit 1
		fi
		break
		;;
	    [Nn])
		break
		;;
	    *)
	        ;;
        esac
    done
fi
rm -rf "$temp_file"

# Create the output directory for temporary files
OUTPUT_DIR=$(mktemp -d)

# Trap to remove the temporary directory on script exit
trap 'rm -rf "$OUTPUT_DIR"' EXIT

# Create a temporary BibTeX file
temp_bibfile="$OUTPUT_DIR/temp.bib"
cp "$input_bib_file" "$temp_bibfile"

# Temporary TeX file name
temp_texfile="$OUTPUT_DIR/temp.tex"

bibtex-tidy --omit=abstract --curly --space=4 --blank-lines --sort=name,year --merge --sort-fields --strip-comments --no-trailing-commas --remove-empty-fields --no-wrap "$input_bib_file" > /dev/null 2>"$OUTPUT_DIR/tidy.log"
if [ $? -ne 0 ]; then
    cat "$OUTPUT_DIR/tidy.log" | grep "Error\|ERROR\|key"
    exit 2 
fi

biber --tool --output_encoding=UTF-8 "$input_bib_file" -O "$OUTPUT_DIR/bibertool.bib"
cp "$OUTPUT_DIR/bibertool.bib" "$input_bib_file"

biber_validation="$(biber --tool -V "$input_bib_file")"
if [ $? -ne 0 ]; then
    errmsg="$(echo "$biber_validation" | grep -E "ERROR.*$entry")"
    printf "$errmsg" | sed s/ERRORS\\?/`printf "${RED}ERROR${NC}"`/
    printf "\n"
    exit 2
fi

# Read each BibTeX entry from the input file and process it
while read -r entry; do
    # temporary TeX file content
    printf '%s\n' \
	'\documentclass{article}' \
	'\begin{document}' \
	"\\cite{$entry}" \
	'\bibliographystyle{plain}' \
	"\\bibliography{$temp_bibfile}" \
	'\end{document}' > "$temp_texfile"
    # Compile the TeX file
    xelatex "$temp_texfile" > /dev/null 2>"$OUTPUT_DIR/xelatex_compilation_error.log" 
    biber "$temp_bibfile" > /dev/null 2>"$OUTPUT_DIR/biber_compilation_error.log"
    xelatex "$temp_texfile" > /dev/null 2>"$OUTPUT_DIR/xelatex_compilation_error.log"
    # Check for compilation errors
    if [ $? -eq 0 ]; then
        echo -e "BibTeX entry compiles ${GREEN}successfully${NC}: $entry"
    else
        echo -e "Compilation ${RED}error${NC} for BibTeX entry: $entry"
	cat "$OUTPUT_DIR/biber_compilation_error.log"
	cat "$OUTPUT_DIR/xelatex_compilation_error.log"
    fi
    warnmsg="$(echo "$biber_validation" | grep -E "WARN.*$entry")"
    printf "$warnmsg" | sed s/WARN/`printf "${YELLOW}WARN${NC}"`/
    # Clean up temporary files
    rm -f "$temp_texfile" "$OUTPUT_DIR"/*.aux "$OUTPUT_DIR"/*.bbl "$OUTPUT_DIR"/*.blg "$OUTPUT_DIR"/*.log "$OUTPUT_DIR"/*.pdf "$OUTPUT_DIR"/*.out
    printf "\n"
done < <(grep "@" "$input_bib_file" | cut -d{ -f2 | cut -d, -f1 | tr -d ' ')
