# An Implementation of the Reduction Model for Incomplete and Multi-Precedent Cases

This repository contains an implementation of the Reduction Model for incomplete and
multi-precedent cases. The implementation utilises answer set program and uses as
its backend the state-of-the-art solver [clingo](https://potassco.org/clingo/).
This repository is an addition to the paper written on the same matter.

## Installation

This project requires [Python 3.13](https://www.python.org/downloads/) or newer.
To install the dependencies, including the Python module for clingo, run:
```bash
> pip install -r requirements.txt
```

## Execution

To execute the program, pass .lp input files via the command line.
The program will then output

```
> python solve.py example/example1.lp
constraint(cf, defendant)
```

### CLI options

Further options, such as `-s` and `-p`, can be specified to adjust the output of the program.

```
> python solve.py --help
usage: solve.py [-h] [-s] [-p] inputfile [inputfile ...]

An implementation of the Reduction Model for incomplete and multi-precedent cases

positional arguments:
  inputfile             an input file in .lp format containing dimensions, cases, and a focus case

options:
  -h, --help            show this help message and exit
  -s, --show-supports   show the minimal supporting thresholds for dimensions
  -p, --show-precedent  show the precedent cases in the output
```

## Implementation Details


