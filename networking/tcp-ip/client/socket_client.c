#include <arpa/inet.h>
#include <errno.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

static int connect_to_server(const char *host, const char *port) {
    struct addrinfo hints = {0};
    struct addrinfo *addresses = NULL;
    struct addrinfo *candidate = NULL;
    int socket_fd = -1;

    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    const int status = getaddrinfo(host, port, &hints, &addresses);
    if (status != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return -1;
    }

    for (candidate = addresses; candidate != NULL; candidate = candidate->ai_next) {
        socket_fd = socket(candidate->ai_family, candidate->ai_socktype, candidate->ai_protocol);
        if (socket_fd < 0) {
            continue;
        }

        if (connect(socket_fd, candidate->ai_addr, candidate->ai_addrlen) == 0) {
            break;
        }

        close(socket_fd);
        socket_fd = -1;
    }

    freeaddrinfo(addresses);
    return socket_fd;
}

static int send_all(int socket_fd, const char *buffer, size_t length) {
    size_t sent = 0;
    while (sent < length) {
        const ssize_t written = send(socket_fd, buffer + sent, length - sent, 0);
        if (written < 0) {
            if (errno == EINTR) {
                continue;
            }
            return -1;
        }
        sent += (size_t)written;
    }
    return 0;
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        fprintf(stderr, "Usage: %s <host> <port> [message]\n", argv[0]);
        return EXIT_FAILURE;
    }

    char input[BUFFER_SIZE] = {0};
    if (argc == 4) {
        snprintf(input, sizeof(input), "%s", argv[3]);
    } else {
        printf("Please enter the message: ");
        if (fgets(input, sizeof(input), stdin) == NULL) {
            fprintf(stderr, "No message received\n");
            return EXIT_FAILURE;
        }
        input[strcspn(input, "\n")] = '\0';
    }

    const int socket_fd = connect_to_server(argv[1], argv[2]);
    if (socket_fd < 0) {
        perror("Unable to connect");
        return EXIT_FAILURE;
    }

    if (send_all(socket_fd, input, strlen(input)) < 0) {
        perror("Unable to send message");
        close(socket_fd);
        return EXIT_FAILURE;
    }
    shutdown(socket_fd, SHUT_WR);

    char response[BUFFER_SIZE] = {0};
    const ssize_t received = recv(socket_fd, response, sizeof(response) - 1, 0);
    if (received < 0) {
        perror("Unable to receive response");
        close(socket_fd);
        return EXIT_FAILURE;
    }

    response[received] = '\0';
    printf("Server response: %s\n", response);
    close(socket_fd);
    return EXIT_SUCCESS;
}
