from sys import argv, stdin, stdout
import json

def use_file(file_or_filename, cb):
    if isinstance(file_or_filename, str):
        with open(file_or_filename) as file:
            return cb(file)

    return cb(file_or_filename)

def write_asp(input_json, output_file):
    pass

def main():
    argc = len(argv)

    input_file = sys.argv[1] if argc >= 2 else stdin
    output_file = sys.argv[2] if argc >= 3 else stdout

    input_json = use_file(input_file, lambda f : json.load(f))
    use_file(output_file, lambda f : write_asp(input_json, f))




if __name__ == '__main__':
    main()