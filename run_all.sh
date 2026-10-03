#!/usr/bin/env bash
# Reproduces every experiment from the video. Linux + gcc (or clang) + pthreads.
set -u
cd "$(dirname "$0")"
make -s all tsan
echo "machine: $(nproc) cores, $(lscpu | grep 'Model name' | sed 's/ \+/ /g'), $(${CC:-gcc} --version | head -1)"

echo; echo "== 1. Racy counter: two threads x 1,000,000 increments (expect 2000000)"
for i in 1 2 3 4 5; do ./bin/race 0; done

echo; echo "== 2. Same program pinned to ONE core (often right, still a data race)"
if command -v taskset >/dev/null; then for i in 1 2 3 4 5; do taskset -c 0 ./bin/race 0; done
else echo "(taskset not found, skipped)"; fi

echo; echo "== 3. ThreadSanitizer on the racy counter"
./bin/race_tsan 0 2>&1 | grep -E "WARNING|SUMMARY" | head -2

echo; echo "== 4. Race condition WITHOUT a data race (bonus rule): expect 101 even though every access is locked"
./bin/bonus
echo "TSan reports on bonus (should be none):"; ./bin/bonus_tsan 2>&1 | grep -c "WARNING: ThreadSanitizer" || true

echo; echo "== 5. Compiler reordering: 'game over' flag"
echo "-O0:"; timeout 3 ./bin/gameover_O0; echo "exit $?"
echo "-O2 (124 = still waiting after 3 s, killed by timeout):"; timeout 3 ./bin/gameover_O2; echo "exit $?"

echo; echo "== 6. Quiz: which one is a data race?"
for q in a b c; do echo "-- $q"; ./bin/quiz_tsan $q 2>&1 | grep -E "^quiz |SUMMARY"; done

echo; echo "== 7. Fixes: lock (mode 1), atomic (mode 2), don't share (own)"
for i in 1 2 3; do ./bin/race 0; done | sed 's/^/racy   /'
for i in 1 2 3; do ./bin/race 1; done | sed 's/^/lock   /'
for i in 1 2 3; do ./bin/race 2; done | sed 's/^/atomic /'
for i in 1 2 3; do ./bin/own;    done | sed 's/^/own    /'
