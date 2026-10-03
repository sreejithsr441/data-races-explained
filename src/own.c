/* Option three: don't share. Each thread counts on its own board; add them up at the end. */
#include <pthread.h>
#include <stdio.h>
#include <time.h>
#define N 1000000
long board[2];
void *work(void *a) { long id = (long)a, mine = 0; for (long i = 0; i < N; i++) mine++; board[id] = mine; return 0; }
double now() { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e3 + t.tv_nsec / 1e6; }
int main(void) {
  pthread_t a, b; double s = now();
  pthread_create(&a, 0, work, (void *)0); pthread_create(&b, 0, work, (void *)1);
  pthread_join(a, 0); pthread_join(b, 0);
  printf("%ld %.1fms\n", board[0] + board[1], now() - s);
}
