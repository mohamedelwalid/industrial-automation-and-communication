#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

static int running = 1;
static int var_1 = 0;
static int var_2 = 0;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static void *writer(void *arg)
{
    (void)arg;
    while (running) {
        pthread_mutex_lock(&mutex);
        ++var_1;
        var_2 = var_1;
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

static void *reader(void *arg)
{
    (void)arg;
    for (int i = 0; i < 20; ++i) {
        pthread_mutex_lock(&mutex);
        printf("Number 1 is %d, number 2 is %d\n", var_1, var_2);
        pthread_mutex_unlock(&mutex);
        usleep(100000);
    }
    running = 0;
    return NULL;
}

int main(void)
{
    pthread_t t1;
    pthread_t t2;

    pthread_create(&t1, NULL, writer, NULL);
    pthread_create(&t2, NULL, reader, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_mutex_destroy(&mutex);
    return 0;
}
