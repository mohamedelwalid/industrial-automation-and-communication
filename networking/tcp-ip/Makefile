CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -O2

.PHONY: all clean

all: client/socket_client server/socket_server

client/socket_client: client/socket_client.c
	$(CC) $(CFLAGS) $< -o $@

server/socket_server: server/socket_server.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f client/socket_client server/socket_server
