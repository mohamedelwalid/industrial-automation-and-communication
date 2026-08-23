# Verification

Run the hardware-free checks from the repository root:

```bash
./scripts/verify_local.sh
```

The checks compile and execute the selected C examples, exercise the TCP/IP
client/server locally, syntax-check the Python modules, run the MQTT publisher
with simulated input and validate PLCopen XML where `xmllint` is available.

Physical Raspberry Pi, sensor, OpenPLC and FTsim operation belongs to the
original laboratory environment and is not required to review the source code.
