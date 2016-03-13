"""
A simple no thrills css minifier.
Removes comments and unnecessary whitespace.
"""
from sys import argv

def minify(css):
  '''
  A simple css minify.
  Removes comments and whitespace, without changing code.
  
  Args:
    css (string): The css to minify.
  Returns:
    Reduced css text (string).
  '''
  minified = ""
  comment = False
  important_whitespace = True
  i = 0
  
  # Process css.
  while i < (len(css) - 1):
    #Get next and current chracters
    current = css[i]
    next = css[i + 1]
    
    # Comment start.
    if current == "/" and next == "*":
      comment = True
      i += 2
      current = css[i]
    # Comment end.
    elif current == "*" and next == "/":
      comment = False
      i += 2
      current = css[i]

    if important_whitespace == "?" and current != " " and current != "\n":
      important_whitespace = True
    # Important whitespace (separation of names and values)
    elif current == "}":
      important_whitespace = "?"
    # Important whitespace (separation of names and values)
    elif current == ":":
      important_whitespace = True
    # Unimportant whitespace.
    elif current == ";" or current == "{":
      important_whitespace = False

    if not comment:
      # Remove newlines.
      if current != "\n":
        # Remove unnecessary spaces.
        if current != " " or (important_whitespace and important_whitespace != "?"):
          # Store character.
          minified += current
    # Next character.
    i += 1

  return minified
  
def minify_file(input_file, output_file):
  '''
  Opens a css file, minifies it and outputs as another file.
  Removes comments and whitespace, without changing code.
  
  Args:
    input_file (string): The css file to minify.
    output_file (string): The output_file.
  '''
  # Open and read css file.
  with open(input_file, encoding="utf-8", mode="r") as input_text:
    css = input_text.read()
  # Minify css.
  css = minify(css)
  # Save minified css.
  with open(output_file, encoding="utf-8", mode="w") as output_text:
    output_text.write(css)
  
if __name__ == "__main__":
  input_file = argv[1]
  output_file = argv[2]
  minify_file(input_file, output_file)