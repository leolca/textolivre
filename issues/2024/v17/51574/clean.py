import re

def clean_bib_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8', errors='ignore') as file:
        content = file.read()

    # Remove non-ASCII characters
    cleaned_content = re.sub(r'[^\x00-\x7F]+', '', content)

    with open(output_file, 'w', encoding='utf-8') as file:
        file.write(cleaned_content)

input_file = 'article.bib'
output_file = 'article_cleaned.bib'
clean_bib_file(input_file, output_file)

