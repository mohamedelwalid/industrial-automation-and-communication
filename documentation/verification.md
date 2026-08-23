# Verification

Run the hardware-free checks from the repository root:

```bash
./scripts/verify_local.sh
```

The checks compile and execute the selected C examples, exercise the TCP/IP
client/server locally, syntax-check the Python modules, run the MQTT publisher
with simulated input and confirm that the four original PLC evidence images
are present.

Physical Raspberry Pi, sensor, OpenPLC and FTsim operation belongs to the
original laboratory environment and is not required to review the source code.
