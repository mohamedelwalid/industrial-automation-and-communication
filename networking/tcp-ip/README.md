# TCP/IP socket communication

This laboratory introduced socket-based communication in C. A client and
server were first run locally in Ubuntu, then across two computers:

```text
macOS → UTM → Ubuntu client → TCP/IP → Raspberry Pi server
```

## Skills demonstrated

- resolving a hostname and port;
- creating, connecting, binding, listening and accepting sockets;
- reading and writing byte streams;
- basic input and error handling;
- repeated message exchange; and
- testing communication across a local network.

## Build and run

```bash
make
./server/socket_server 5000
./client/socket_client localhost 5000 "Hello World"
```

For a two-machine setup, run the server on the Raspberry Pi and replace
`localhost` with the Pi's current local IP address.
