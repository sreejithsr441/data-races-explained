/* Race condition WITHOUT a data race: every access to score holds the lock,
   but A's check ("under 100?") and A's act ("add bonus") are separate turns. */
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
long score = 99;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
void *keeper_a(void *x) {
  pthread_mutex_lock(&m); int under = score < 100; pthread_mutex_unlock(&m);  /* check */
  usleep(50000);                                                             /* puts the marker down */
  if (under) { pthread_mutex_lock(&m); score += 1; pthread_mutex_unlock(&m); } /* bonus */
  return 0;
}
void *keeper_b(void *x) {
  usleep(20000);
  pthread_mutex_lock(&m); score += 1; pthread_mutex_unlock(&m);               /* a normal point */
  return 0;
}
int main(void) {
  pthread_t a, b;
  pthread_create(&a, 0, keeper_a, 0); pthread_create(&b, 0, keeper_b, 0);
  pthread_join(a, 0); pthread_join(b, 0);
  printf("final score: %ld (bonus rule: only if under 100)\n", score);
}
