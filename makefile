OBJS = fetch.o show.o git-issues.o
CC = gcc
CPPC = g++

CFLAGS = -Wall -c -O3
LFLAGS = -Wall -O3
EXE_NAME = git-issues

# DEFAULT TARGET
make: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o $(EXE_NAME)


# OBJECTS
git-issues.o: git-issues.c git-issues.h
	$(CC) $(CFLAGS) git-issues.c

show.o: show.c show.h
	$(CC) $(CFLAGS) show.c

fetch.o: fetch.c fetch.h
	$(CC) $(CFLAGS) fetch.c


# CUSTOM TARGETS
run: make
	./$(EXE_NAME)
show: make
	./$(EXE_NAME) show
fetch: make
	./$(EXE_NAME) fetch

# remove all object files, preprocessor outputs and the built executable
clean:
	rm -f *.o
	rm -f $(EXE_NAME)

tar:
	tar cfv $(EXE_NAME).tar $(OBJS)
