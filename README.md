# Data Races Explained Simply: the code

Companion code for the YouTube video **"What is a Data Race? (Why 1 + 1 = 1 in Your Code)"**.
Every number shown in the video came from these programs.

Requirements: Linux, gcc or clang, pthreads. ThreadSanitizer ships with both compilers.

```bash
make            # normal builds (-O0, plus gameover at -O0 and -O2)
make tsan       # ThreadSanitizer builds
./run_all.sh    # runs every experiment from the video
```

## The programs

| File | Video section | What it shows |
|---|---|---|
| `src/race.c` | 1+1=1?, Right answer still a bug, How to fix it | Two threads each add 1 to a shared counter 1,000,000 times. `./bin/race 0` racy, `1` with a mutex, `2` with an atomic. Prints the result and the time. |
| `src/bonus.c` | Data race vs race condition | Every access is locked (no data race), but the check-then-act plan still breaks: score ends at 101. |
| `src/gameover.c` | The sneakier way: reordering | A plain `int` flag. At `-O0` thread B sees "game over". At `-O2` the compiler reads the flag once and B waits forever. |
| `src/quiz.c` | Quiz | `./bin/quiz_tsan a`, `b`, `c`. Only C is a data race, and only C gets a ThreadSanitizer warning. |
| `src/own.c` | How to fix it, option 3 | Don't share: each thread counts on its own board, then add them up. |

`racy` is mode `0` in `race.c`; the racing line is `counter++` on line 11, which is the line ThreadSanitizer names.

## Results from the video

Measured on small Linux cloud VMs (2 vCPU Intel Xeon, gcc 13.3, `-O0`). Raw logs are in `results/`.

| Experiment | Result |
|---|---|
| Racy counter, 2 cores | 1,193,016 and 1,272,763 (expected 2,000,000); 0 of 11 runs correct |
| Racy counter pinned to 1 core (`taskset -c 0`) | Usually 2,000,000, but not always; TSan still reports a data race at `race.c:11` |
| Bonus rule, all accesses locked | 101 every run, no TSan warning |
| Game-over flag | `-O0` finishes, `-O2` hangs (killed by `timeout` after 3 s) |
| Racy vs lock vs atomic (2 cores, median of 11) | about 5 ms / 161 ms / 40 ms |
| Own board each | about 1 ms |

The lock is about 30x slower here, but that's a worst case: the loop does nothing except add. In real code the gap is usually far smaller. Your numbers will differ by machine. Run `./run_all.sh` and compare.

## Things to know

- **A right answer doesn't prove the code is right.** Run with `-fsanitize=thread` while testing.
- ThreadSanitizer slows programs down a lot (Clang docs: typically 5x-15x), so use it in tests rather than production.
- In Go, the same check is `go test -race ./...`.
- Safe Rust rejects data races at compile time.

## Further reading

- ThreadSanitizer (Clang): https://clang.llvm.org/docs/ThreadSanitizer.html
- Go race detector: https://go.dev/doc/articles/race_detector
- The Rustonomicon, Data Races and Race Conditions: https://doc.rust-lang.org/nomicon/races.html
- A Study of Real-World Data Races in Golang (Uber, PLDI 2022): https://arxiv.org/abs/2204.00764

## License

MIT. Use it, copy it, teach with it.
