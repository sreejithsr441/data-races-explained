/* Quiz: which one is a data race?  ./quiz a|b|c   (build with -fsanitize=thread)
   A: two threads read the same score, nobody writes
   B: two threads add to the same score, each waits for the marker (mutex) first
   C: one thread writes the score while another reads it, no waiting */
#include <pthread.h>
#include <stdio.h>
long score = 10; long seen;
pthread_mutex_t marker = PTHREAD_MUTEX_INITIALIZER;
char mode;
void *t1(void *x) {
  if (mode == 'a') seen = score;
  if (mode == 'b') { pthread_mutex_lock(&marker); score += 1; pthread_mutex_unlock(&marker); }
  if (mode == 'c') score += 1;
  return 0;
}
void *t2(void *x) {
  long r = 0;
  if (mode == 'a') r = score;
  if (mode == 'b') { pthread_mutex_lock(&marker); score += 1; pthread_mutex_unlock(&marker); }
  if (mode == 'c') r = score;
  return (void *)r;
}
int main(int c, char **v) {
  mode = v[1][0]; pthread_t a, b;
  pthread_create(&a, 0, t1, 0); pthread_create(&b, 0, t2, 0);
  pthread_join(a, 0); pthread_join(b, 0);
  printf("quiz %c: score %ld\n", mode, score);
}
