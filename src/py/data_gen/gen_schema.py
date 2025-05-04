from sys import argv, stdin, stdout
import json


def use_file(file_or_filename, mode, cb):
    if isinstance(file_or_filename, str):
        with open(file_or_filename, mode) as file:
            return cb(file)

        raise

    return cb(file_or_filename)


def gen_schema_dict(num_dimensions, num_cases):
    dimension_defs = dict({})
    cases = dict({})

    schema = dict({
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "$id": "",
        "title": "DimReasonModel",
        "description": f"[AUTO GENERATED] for {num_dimensions} dimensions and {num_cases}",
        "type": "object",
        "additionalProperties": False,
        "required": ["fact_definitions", "past_cases"],
        "properties": {
            "fact_definitions": dimension_defs,
            "cases": cases
        },
    })

    for id in range(1, num_dimensions + 1):
        d

    for c in range(1, num):

    return schema


def write_schema(num_dimensions, num_cases, file):
    schema = gen_schema_dict(num_dimensions, num_cases)

    schema_json = json.dumps(schema, indent=4)
    file.write(schema_json)



def main():
    argc = len(argv)

    num_dimensions = argv[1] if argc >= 2 else 10
    num_cases = argv[2] if argc >= 3 else 10

    output_file = argv[3] if argc >= 4 else stdout
    use_file(output_file, "w", lambda f : write_schema(num_dimensions, num_cases, f))


if __name__ == '__main__':
    main()