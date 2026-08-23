# How the laboratories build on one another

The TPK4128 assignments are independent laboratories rather than one deployed
system. Together they establish a useful industrial-mechatronics stack:

1. **Linux and C** provide the development environment and low-level software
   foundation.
2. **Processes, threads and memory** introduce concurrency and reliable
   resource handling.
3. **TCP/IP** moves data between software running on separate computers.
4. **Ladder Diagram and SFC** describe machine control and process sequence.
5. **OPC UA** exposes structured machine data, methods and events.
6. **MQTT** distributes lightweight telemetry through a broker.
7. **ROS2** coordinates modular nodes through topics, services and actions.

The progression moves from local code, to device-to-device communication, to
control logic and finally to higher-level industrial middleware.
