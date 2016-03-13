from os import path
import cssMinify

def main(*args, **kwargs):
  input_file = path.join(kwargs["@"], args[0])
  output_file = path.join(kwargs["@"], args[1])
  cssMinify.minify_file(input_file, output_file)