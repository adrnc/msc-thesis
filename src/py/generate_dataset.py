import random

### INPUT ###

case_number = 20

def value_list(start, stop, step):
    return list(range(start, stop + 1, step))

dimensions = [
    {
        "name": "protest",
        "strengthens": "plaintiff",
        "values": ["none", "complained", "cried", "screamed", "kicked"]
    },
    {
        "name": "screen",
        "strengthens": "plaintiff",
        "values": value_list(0, 300, 15),
        "magnitude_values": value_list(0, 300, 30)
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

        plaintiff_prob = index / values_len
        plaintiff_prob = max(0, min(1, plaintiff_prob))

        plaintiff_probs.append(plaintiff_prob)

        facts.append({
            "name": dim["name"],
            "value": value,
            "plaintiff_prob": plaintiff_prob
        })

    plaintiff_total_prob = sum(plaintiff_probs) / dimensions_len
    side = "plaintiff" if random.random() >= plaintiff_total_prob else "defendant"

    magnitudes = []

    while len(magnitudes) == 0:
        for fact in facts:
            threshold = fact["plaintiff_prob"]

            if side == "plaintiff":
                threshold = 1 - threshold

            if random.random() < threshold:
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
        "side": side,
        "facts": facts,
        "magnitudes": magnitudes
    })

sep = r"%%%"

print(f"{sep} DIMENSIONS {sep}\n")

for dim in dimensions:
    dim_name = dim["name"]
    dim_strengthens = dim["strengthens"]
    dim_values = dim["values"]

    if isinstance(dim_values[0], int):
        print(f"int_dimension_strengthens({dim_name}, {dim_strengthens}).")
    else:
        print(f"custom_dimension_strengthens({dim_name}, {dim_strengthens}).")

        for i in range(1, len(dim_values)):
            print(f"custom_dimension_ordering({dim_name}, {dim_values[i - 1]}, {dim_values[i]}).")

    print()

print(f"{sep} CASES {sep}\n")

cases.sort(key=lambda x: 0 if x["side"] == "plaintiff" else 1)

case_id = 1

for case in cases:
    print(f"case({case_id}, {case["side"]}).")

    for fact in case["facts"]:
        print(f"value_assignment({case_id}, {fact["name"]}, {fact["value"]}).")

    for magnitude in case["magnitudes"]:
        print(f"magnitude_factor({case_id}, {magnitude["name"]}, {magnitude["value"]}).")

    print()

    case_id += 1
