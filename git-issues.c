#include "git-issues.h"



int main(int argc, char const *argv[]) {
    if (argc != 2) {
        printf("Usage: git-issues show|fetch\n");
        return 1;
    }

    const char* action = argv[1];
    printf("%s\n", action);

    system("echo 'asdf';");

    return 0;
}
