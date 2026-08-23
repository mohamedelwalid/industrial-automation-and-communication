#include <pthread.h>
#include <stdio.h>

int global_var = 0;

static void *task(void *arg)
{
    (void)arg;
    int local_var = 0;

    for (int i = 0; i < 5; ++i) {
        ++global_var;
        ++local_var;
    }

    printf("Thread: Global = %d, Local = %d\n", global_var, local_var);
    return NULL;
}

int main(void)
{
    pthread_t t1;
    pthread_t t2;

    pthread_create(&t1, NULL, task, NULL);
    pthread_create(&t2, NULL, task, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Main: Final global = %d\n", global_var);
    return 0;
}
