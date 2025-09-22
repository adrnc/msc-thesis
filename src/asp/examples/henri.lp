int_dimension_strengthens(income, plaintiff).

custom_dimension_strengthens(pet, plaintiff).
custom_dimension_ordering(pet, none, fish).
custom_dimension_ordering(pet, fish, cat).

case(c, plaintiff).
fact(c, income, 1200).
fact(c, pet, none).
magnitude(c, income, 1000).

case(b, defendant).
fact(b, income, 1100).
fact(b, pet, fish).
magnitude(b, income, 1150).
magnitude(b, pet, cat).
