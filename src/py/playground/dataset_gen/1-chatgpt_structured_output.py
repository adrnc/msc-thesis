import json
from textwrap import dedent
from openai import OpenAI
client = OpenAI()

MODEL = "gpt-4o-2024-08-06"

prompt = '''
    You are a helpful math tutor. You will be provided with a math problem,
    and your goal will be to output a step by step solution, along with a final answer.
    For each step, just provide the output as an equation use the explanation field to detail the reasoning.
'''

def get_dataset(question):
    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {
                "role": "system",
                "content": dedent(prompt)
            },
            {
                "role": "user",
                "content": question
            }
        ],
        response_format={
            "type": "json_schema",
            "json_schema": {
                "name": "dimensional_reason_model_dataset",
                "schema": {
                    "type": "object",
                    "additionalProperties": False,
                    "required": ["dimensional_fact_definitions", "past_cases"],
                    "properties": {
                        "dimensional_fact_definitions": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "additionalProperties": False,
                                "required": ["id", "description", "strengthens", "min_value", "max_value"],
                                "properties": {
                                    "id": { "type": "integer", "minimum": 0 },
                                    "description": { "type": "string" },
                                    "strengthens": { "enum": ["defendant", "plaintiff"] },
                                    "min_value": { "type": "integer" },
                                    "max_value": { "type": "integer" },
                                },
                            },
                        },
                        "past_cases": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "additionalProperties": False,
                                "required": ["id", "description", "winner", "dimensional_facts"],
                                "properties": {
                                    "id": { "type": "integer", "minimum": 0 },
                                    "description": { "type": "string" },
                                    "winner": { "enum": ["defendant", "plaintiff"] },
                                    "dimensional_facts": {
                                        "type": "array",
                                        "items": {
                                            "type": "object",
                                            "additionalProperties": False,
                                            "required": ["dimension_id", "value"],
                                            "properties": {
                                                "dimension_id": { "type": "integer", "minimum": 0 },
                                                "value": { "type": "integer" },
                                            },
                                        },
                                    },
                                    "decision_reasons": {
                                        "type": "array",
                                        "items": {
                                            "type": "object",
                                            "additionalProperties": False,
                                            "required": ["dimension_id", "value"],
                                            "properties": {
                                                "dimension_id": { "type": "integer", "minimum": 0 },
                                                "satisfies_value": { "type": "integer" },
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
                "strict": True,
            },
        }
    )

    return response.choices[0].message

question = "Give me a case base of with 10 cases and overlapping facts"

result = get_dataset(question)

print(result.content)