import os
import sys
import openai
openai.api_key = os.getenv("OPENAI_KEY")

if len(sys.argv) == 2:
    abstract = sys.argv[1]
else:
    print("Usage: python process_abstract.py <abstract>")
    sys.exit(1)

completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
      {"role": "system", "content": "You are a scientific expert in article classification, based on their abstract provided by the user, according to the UIS 'Research Fields and Disciplines' classification. You will give one single classification with at least three levels from the most broad area to the most specific subfield. The answer should be in the format: Field: field-name; Subfield: subfield-name; Sub-subfield: subsubfield-name."},
    {"role": "user", "content": abstract}
  ]
)

print(completion.choices[0].message)
