from sys import argv, stdin, stdout
import json


USE_ID_PREFIX = True


def id(pre, value):
    return f"{pre if USE_ID_PREFIX else ""}{value}"


def use_file(file_or_filename, mode, cb):
    if isinstance(file_or_filename, str):
        with open(file_or_filename, mode) as file:
            return cb(file)

    return cb(file_or_filename)


def write_asp(input_json, output_file):
    delim = r"%%%"

    output_file.write(f"{delim} DIMENSION DEFINITIONS {delim}\n\n")

    for d in input_json["dimensional_fact_definitions"]:
        output_file.write(f"dimension_definition({id("d", d["id"])}, {d["strengthens"]}, {d["min_value"]}, {d["max_value"]}).\n")

    output_file.write(f"\n{delim} CASE BASE {delim}\n\n")

    for c in input_json["past_cases"]:
        c_id = id("c", c["id"])

        output_file.write(f"% CASE {c_id}: {c["description"]}\n")
        output_file.write(f"case({c_id}, {c["winner"]}).\n")

        for f in c["dimensional_facts"]:
            output_file.write(f"dimensional_fact({c_id}, {id("d", f["dimension_id"])}, {f["value"]}).\n")

        for m in c["decision_reasons"]:
            output_file.write(f"reason_magnitude({c_id}, {id("d", m["dimension_id"])}, {m["satisfies_value"]}).\n")

        output_file.write("\n")


def main():
    argc = len(argv)

    input_file = argv[1] if argc >= 2 else stdin
    output_file = argv[2] if argc >= 3 else stdout

    input_json = use_file(input_file, "r", lambda f : json.load(f))
    use_file(output_file, "w", lambda f : write_asp(input_json, f))


if __name__ == '__main__':
    main()