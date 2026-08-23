# E9 Sequential Function Chart

## Submitted files

The supplied `E9-SFC.zip` contains the PLCopen source, generated Structured Text,
variable table and a later compiled OpenPLC library. This establishes that the
SFC was repaired and compiled after the original E9 submission, which had
reported a compile failure.

`source/` preserves the submitted Beremiz project. `generated/` contains
reviewable generated files; platform-specific object files and libraries are
not committed.

## Mapped process I/O

The source maps the conveyor outputs to `%QX0.4`, `%QX0.5`, `%QX0.7` and
`%QX1.1`, process stations to `%QX0.6` and `%QX1.0`, transfer outputs to
`%QX0.0`–`%QX0.3`, and relevant sensors across `%IX0.2`–`%IX1.2`.

## Known limitations

- Compilation is supported by the later build artefacts, but runtime operation
  has not yet been reproduced in this repository.
- `start_button` is not assigned a physical input address.
- The submitted chart is a single sequential chain. It does not by itself
  demonstrate simultaneous handling of multiple workpieces.
- FTsim/OpenPLC testing is still required to verify transitions, actuator
  timing, reset behaviour and safe restart.

These limitations are kept explicit so the repository distinguishes the
submitted coursework from a fully validated industrial control sequence.
