#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/stat.h>

/*
 * Generic launcher: exists only to have its own stable code identity for
 * TCC / Full Disk Access purposes, so we grant FDA once to this binary
 * instead of granting it to /bin/bash (which would cover every bash
 * script on the system).
 *
 * Usage: fda-launcher /path/to/script [args...]
 *
 * As a guardrail, it will only exec scripts that live under TRUSTED_DIR
 * below. That directory must be root-owned and not writable by anyone
 * else, since anything placed there can run with whatever privileges
 * this wrapper has been granted (currently: Full Disk Access).
 *
 * The requested path is canonicalized with realpath() before being
 * checked and exec'd, so "../" traversal and symlinks pointing outside
 * TRUSTED_DIR can't bypass the check.
 */
#define TRUSTED_DIR "/usr/local/bin/env-setup/"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s /path/to/script [args...]\n", argv[0]);
        return 64; /* EX_USAGE */
    }

    char resolved[PATH_MAX];
    if (realpath(argv[1], resolved) == NULL) {
        perror("realpath");
        return 1;
    }

    /* Runtime guard: verify TRUSTED_DIR is root-owned and not world-writable.
     * This catches permission drift after install (e.g. misconfigured automation). */
    struct stat st;
    if (stat(TRUSTED_DIR, &st) != 0 || st.st_uid != 0 || (st.st_mode & S_IWOTH)) {
        fprintf(stderr, "TRUSTED_DIR ownership/permissions check failed: %s\n", TRUSTED_DIR);
        return 1;
    }

    if (strncmp(resolved, TRUSTED_DIR, strlen(TRUSTED_DIR)) != 0) {
        fprintf(stderr, "refusing to exec script outside %s: %s (resolved: %s)\n",
                TRUSTED_DIR, argv[1], resolved);
        return 1;
    }

    execv(resolved, &argv[1]);
    /* only reached if execv fails */
    perror("execv");
    return 1;
}
