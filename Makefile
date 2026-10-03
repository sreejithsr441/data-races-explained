CC      ?= gcc
CFLAGS  ?= -O0 -g -pthread
BIN     := bin

all: $(BIN)/race $(BIN)/bonus $(BIN)/gameover_O0 $(BIN)/gameover_O2 $(BIN)/quiz $(BIN)/own

$(BIN):
	mkdir -p $(BIN)

$(BIN)/race: src/race.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@
$(BIN)/bonus: src/bonus.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@
$(BIN)/quiz: src/quiz.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@
$(BIN)/own: src/own.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@
# same source, two optimisation levels: -O2 hoists the flag read out of the loop
$(BIN)/gameover_O0: src/gameover.c | $(BIN)
	$(CC) -O0 -g -pthread $< -o $@
$(BIN)/gameover_O2: src/gameover.c | $(BIN)
	$(CC) -O2 -g -pthread $< -o $@

# ThreadSanitizer builds (gcc or clang)
tsan: | $(BIN)
	$(CC) -fsanitize=thread -g -O1 -pthread src/race.c  -o $(BIN)/race_tsan
	$(CC) -fsanitize=thread -g -O1 -pthread src/quiz.c  -o $(BIN)/quiz_tsan
	$(CC) -fsanitize=thread -g -O1 -pthread src/bonus.c -o $(BIN)/bonus_tsan

clean:
	rm -rf $(BIN)

.PHONY: all tsan clean
