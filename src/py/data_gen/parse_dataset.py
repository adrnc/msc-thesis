from sys import argv, stdin, stdout
import json


def use_file(file_or_filename, mode, cb):
    if isinstance(file_or_filename, str):
        with open(file_or_filename, mode) as file:
            return cb(file)

        raise

    return cb(file_or_filename)


def write_asp(input_json, output_file):
    delim = r"%%%"

    output_file.write(f"{delim} DIMENSION DEFINITIONS {delim}\n\n")

    for d in input_json["fact_definitions"]:
        output_file.write(f"dimension_definition({d["id"]}, {d["strengthens_side"]}, {d["min_value"]}, {d["max_value"]}).\n")

    output_file.write(f"\n{delim} CASE BASE {delim}\n\n")

    for c in input_json["past_cases"]:
        c_id = c["id"]

        output_file.write(f"% CASE {c_id}: {c["description"]}\n")
        output_file.write(f"case({c_id}, {c["winning_side"]}).\n")

        magnitude_output = []

        for f in facts:
            d_id = f["referenced_fact_id"]

            output_file.write(f"dimensional_fact({c_id}, {d_id}, {f["value"]}).\n")

            if f["used_for_reason"]:
                magnitude_strings.append(f"reason_magnitude({c_id}, {d_id}, {m["reason_value"]}).\n")

        for m in magnitude_output:
            output_file.write(m)

        output_file.write("\n")


def main():
    argc = len(argv)

    input_file = argv[1] if argc >= 2 else stdin
    output_file = argv[2] if argc >= 3 else stdout

    input_json = use_file(input_file, "r", lambda f : json.load(f))
    use_file(output_file, "w", lambda f : write_asp(input_json, f))


if __name__ == '__main__':
    main()