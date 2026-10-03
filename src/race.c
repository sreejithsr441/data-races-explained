#include <pthread.h>
#include <stdio.h>
#include <stdatomic.h>
#include <time.h>
#define N 1000000
long counter = 0; atomic_long acounter = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
int mode;
void *work(void *a) {
  for (long i = 0; i < N; i++) {
    if (mode == 0) counter++;
    else if (mode == 1) { pthread_mutex_lock(&m); counter++; pthread_mutex_unlock(&m); }
    else atomic_fetch_add(&acounter, 1);
  }
  return 0;
}
double now() { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e3 + t.tv_nsec / 1e6; }
int main(int c, char **v) {
  mode = v[1][0] - '0'; pthread_t a, b; double s = now();
  pthread_create(&a, 0, work, 0); pthread_create(&b, 0, work, 0);
  pthread_join(a, 0); pthread_join(b, 0);
  printf("%ld %.1fms\n", mode == 2 ? acounter : counter, now() - s);
}
