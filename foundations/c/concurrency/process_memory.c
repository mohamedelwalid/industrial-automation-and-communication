#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int global_var = 0;

int main(void)
{
    int local_var = 0;
    pid_t pid = fork();

    for (int i = 0; i < 5; ++i) {
        ++global_var;
        ++local_var;
    }

    if (pid == 0) {
        printf("Child process: Global = %d, Local = %d\n", global_var, local_var);
    } else {
        printf("Parent process: Global = %d, Local = %d\n", global_var, local_var);
    }

    return 0;
}
