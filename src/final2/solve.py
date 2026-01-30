from os import path
from sys import argv
from clingo import Control, Model

def solve(asp_dir: str, input_files: str, show_supports: bool, show_precedents: bool, show_constraint: bool):
    ctl1 = Control(["--enum-mode=cautious"])
    ctl1.load(f"{asp_dir}/step1.lp")

    for file in input_files:
        ctl1.load(file)

    ctl1.ground([("base", [])])

    cautious_atoms = []

    def on_model_step1(model: Model):
        nonlocal cautious_atoms
        cautious_atoms = model.symbols(shown=True)

    ctl1.solve(on_model=on_model_step1)

    show = []

    if show_supports:
        show.append("min_supports/3")
    if show_precedents:
        show.append("precedent/3")
    if show_constraint:
        show.append("constraint/2")

    ctl2 = Control(["--project", f"--show {",".join(show)}"])
    ctl2.load(f"{asp_dir}/step2.lp")

    with ctl2.backend() as backend:
        for atom in cautious_atoms:
            atom_id = backend.add_atom(atom)
            backend.add_rule([atom_id])

    ctl2.ground([("base", [])])
    ctl2.solve(on_model=lambda m: print(f"Answer: {m}"))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='Model',
        description='An implementation of the Reduction Model for incomplete and multi-precedent cases')

    parser.add_argument('filename')
    parser.add_argument('-s', '--show-supports')
    parser.add_argument('-p', '--show-precedents')
    parser.add_argument('-c', '--show-constraint')

    if len(argv) <= 1:
        print("No inputs file provided")
        exit(1)

    solve(f"{path.dirname(__file__)}/asp", argv[1:])
