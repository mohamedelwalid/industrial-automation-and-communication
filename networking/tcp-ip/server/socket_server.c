#include <ctype.h>
#include <errno.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUFFER_SIZE 1024
#define BACKLOG 8

static void reap_children(int signal_number) {
    (void)signal_number;
    while (waitpid(-1, NULL, WNOHANG) > 0) {
    }
}

static void handle_client(int client_fd) {
    char buffer[BUFFER_SIZE] = {0};
    size_t used = 0;

    while (used < sizeof(buffer) - 1) {
        const ssize_t received = recv(client_fd, buffer + used, sizeof(buffer) - 1 - used, 0);
        if (received == 0) {
            break;
        }
        if (received < 0) {
            if (errno == EINTR) {
                continue;
            }
            perror("recv");
            return;
        }
        used += (size_t)received;
    }

    buffer[used] = '\0';
    printf("Received message: %s\n", buffer);
    fflush(stdout);

    for (size_t index = 0; index < used; ++index) {
        buffer[index] = (char)tolower((unsigned char)buffer[index]);
    }

    size_t sent = 0;
    while (sent < used) {
        const ssize_t written = send(client_fd, buffer + sent, used - sent, 0);
        if (written < 0) {
            if (errno == EINTR) {
                continue;
            }
            perror("send");
            return;
        }
        sent += (size_t)written;
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        return EXIT_FAILURE;
    }

    char *end = NULL;
    const long port = strtol(argv[1], &end, 10);
    if (*argv[1] == '\0' || *end != '\0' || port < 1 || port > 65535) {
        fprintf(stderr, "Invalid port: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    signal(SIGCHLD, reap_children);

    const int server_fd = socket(AF_INET6, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("socket");
        return EXIT_FAILURE;
    }

    const int reuse = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));

    struct sockaddr_in6 address = {0};
    address.sin6_family = AF_INET6;
    address.sin6_addr = in6addr_any;
    address.sin6_port = htons((uint16_t)port);

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind");
        close(server_fd);
        return EXIT_FAILURE;
    }
    if (listen(server_fd, BACKLOG) < 0) {
        perror("listen");
        close(server_fd);
        return EXIT_FAILURE;
    }

    printf("TCP server listening on port %ld\n", port);
    fflush(stdout);

    while (1) {
        const int client_fd = accept(server_fd, NULL, NULL);
        if (client_fd < 0) {
            if (errno == EINTR) {
                continue;
            }
            perror("accept");
            break;
        }

        const pid_t child = fork();
        if (child == 0) {
            close(server_fd);
            handle_client(client_fd);
            close(client_fd);
            _exit(EXIT_SUCCESS);
        }
        if (child < 0) {
            perror("fork");
        }
        close(client_fd);
    }

    close(server_fd);
    return EXIT_FAILURE;
}
