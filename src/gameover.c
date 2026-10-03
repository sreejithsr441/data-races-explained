/* Keeper B waits for a "game over" flag; keeper A sets it after 100 ms.
   The flag is shared WITHOUT synchronization (a data race). */
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
int game_over = 0;                      /* plain int: no atomics, no lock */
void *keeper_b(void *x) {
  while (!game_over) { }                /* keep looking at the sign */
  puts("B: saw game over, going home");
  return 0;
}
int main(void) {
  pthread_t b; pthread_create(&b, 0, keeper_b, 0);
  usleep(100000);
  game_over = 1;                        /* A flips the sign */
  puts("A: flipped the sign to game over");
  pthread_join(b, 0);
  puts("done");
}
