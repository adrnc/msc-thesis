from sys import argv, stdin, stdout
import json

USE_ID_PREFIX = True

def id(pre, value):
    return f"{pre if USE_ID_PREFIX else ""}{value}"

def use_file(file_or_filename, cb):
    if isinstance(file_or_filename, str):
        with open(file_or_filename) as file:
            return cb(file)

    return cb(file_or_filename)

def write_asp(input_json, output_file):
    delim = r"%%%"

    print(f"{delim} DIMENSION DEFINITIONS {delim}\n")

    for d in input_json["dimensional_fact_definitions"]:
        print(f"dimension_definition({id("d", d["id"])}, {d["strengthens"]}, {d["min_value"]}, {d["max_value"]}).")

    print(f"\n{delim} CASE BASE {delim}\n")

    for c in input_json["past_cases"]:
        c_id = id("c", c["id"])

        print(f"% CASE {c_id}: {c["description"]}")
        print(f"case({c_id}, {c["winner"]}).")

        for f in c["dimensional_facts"]:
            print(f"dimensional_fact({c_id}, {id("d", f["dimension_id"])}, {f["value"]}).")

        for m in c["decision_reasons"]:
            print(f"reason_magnitude({c_id}, {id("d", m["dimension_id"])}, {m["satisfies_value"]}).")

        print()



def main():
    argc = len(argv)

    input_file = argv[1] if argc >= 2 else stdin
    output_file = argv[2] if argc >= 3 else stdout

    input_json = use_file(input_file, lambda f : json.load(f))
    use_file(output_file, lambda f : write_asp(input_json, f))




if __name__ == '__main__':
    main()