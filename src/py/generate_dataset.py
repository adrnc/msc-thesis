import random

### INPUT ###

case_number = 20
output_type = "asp"

def value_list(start, stop, step):
    return list(range(start, stop + 1, step))

dimensions = [
    {
        "name": "screen",
        "strengthens": "plaintiff",
        "values": value_list(0, 300, 15),
        "magnitude_values": value_list(0, 300, 30)
    },
    {
        "name": "protest",
        "strengthens": "plaintiff",
        "values": ["none", "complained", "cried", "screamed", "kicked"]
    },
    {
        "name": "activity",
        "strengthens": "defendant",
        "values": value_list(0, 300, 15),
        "magnitude_values": value_list(0, 300, 30),
    },
    {
        "name": "coop",
        "strengthens": "defendant",
        "values": ["physical", "verbal", "ignored", "played"]
    },
    {
        "name": "read",
        "strengthens": "defendant",
        "values": value_list(0, 100, 5),
        "magnitude_values": value_list(0, 100, 10)
    }
]

### PROGRAM ###

dimensions_dict = dict()
dimensions_len = len(dimensions)

for dim in dimensions:
    dimensions_dict[dim["name"]] = dim

cases = []

for case_id in range(1, case_number + 1):
    facts = []
    plaintiff_probs = []

    for dim in dimensions:
        values = dim["values"]
        values_len = len(values)

        value = random.choice(values)
        index = values.index(value)

        if dim["strengthens"] == "defendant":
            index = values_len - index

        plaintiff_probs.append(index / values_len)

        facts.append({
            "name": dim["name"],
            "value": value
        })

    plaintiff_prob = sum(plaintiff_probs) / dimensions_len
    side = "plaintiff" if random.random() >= plaintiff_prob else "defendant"

    magnitudes = []

    fixed_fact = random.choice(facts)

    for fact in facts:
        if random.random() < 0.5 and fixed_fact != fact:
            continue

        fact_name = fact["name"]
        fact_value = fact["value"]

        dim = dimensions_dict[fact_name]
        dim_values = dim["values"]
        dim_magnitude_values =  dim["magnitude_values"] if "magnitude_values" in dim else dim_values

        dim_allowed_values = []

        if side == dim["strengthens"]:
            for value in dim_values:
                dim_allowed_values.append(value)

                if value == fact_value:
                    break
        else:
            value_reached = False

            for value in dim_values:
                if value == fact_value:
                    value_reached = True

                if value_reached:
                    dim_allowed_values.append(value)

            dim_allowed_values.reverse()

        dim_allowed_magnitude_values = []

        for value in dim_allowed_values:
            if value in dim_magnitude_values:
                dim_allowed_magnitude_values.append(value)

        dim_scaled_allowed_magnitude_values = []

        i = 1
        for value in dim_allowed_magnitude_values:
            for _ in range(i):
                dim_scaled_allowed_magnitude_values.append(value)

            i += 1

        random.shuffle(dim_scaled_allowed_magnitude_values)
        value = random.choice(dim_scaled_allowed_magnitude_values)

        magnitudes.append({
            "name": fact_name,
            "value": value
        })


    cases.append({
        "id": case_id,
        "side": side,
        "facts": facts,
        "magnitudes": magnitudes
    })

for case in cases:
    case_name = f"case_{case["id"]}"

    print(f"case({case_name}, {case["side"]}).")

    for fact in case["facts"]:
        print(f"fact({case_name}, {fact["name"]}, {fact["value"]}).")

    for magnitude in case["magnitudes"]:
        print(f"magnitude({case_name}, {magnitude["name"]}, {magnitude["value"]}).")

    print()
