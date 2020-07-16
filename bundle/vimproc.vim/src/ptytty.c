/* vim:set sw=4 sts=4 et: */

/* for ptsname_r */
#if defined __ANDROID__
# define _GNU_SOURCE
#endif

#include <sys/types.h>
#include <sys/ioctl.h>

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#if defined __sun__
# include <stropts.h>
#endif
#include <unistd.h>
#include <termios.h>

#include "ptytty.h"

static int
ptsname_compat(int fd, char **buf)
{
#if defined __ANDROID__
    static char b[16];

    if (ptsname_r(fd, b, sizeof(b)) == -1)
        return -1;
    *buf = b;
#else
    if ((*buf = ptsname(fd)) == NULL)
        return -1;
#endif
    return 0;
}

static int
_internal_get_pty(int *master, char **path)
{
    if ((*master = open("/dev/ptmx", O_RDWR|O_NOCTTY)) == -1)
        return -1;
    if (grantpt(*master) != 0)
        return -1;
    if (unlockpt(*master) != 0)
        return -1;
    if (ptsname_compat(*master, path) == -1)
        return -1;

    return 0;
}

static int
_internal_get_tty(int *slave, const char *path,
        struct termios *termp, struct winsize *winp, int ctty)
{
    if (path != NULL) {
        if ((*slave = open(path, O_RDWR|O_NOCTTY)) == -1)
            return -1;
    }
#ifdef TIOCSCTTY
    if (ctty && ioctl(*slave, TIOCSCTTY, NULL) == -1)
        return -1;
#endif
#ifdef I_PUSH
    if (ioctl(*slave, I_PUSH, "ptem") == -1)
        return -1;
    if (ioctl(*slave, I_PUSH, "ldterm") == -1)
        return -1;
#if defined __sun__
    if (ioctl(*slave, I_PUSH, "ttcompat") == -1)
        return -1;
#endif
#endif

    if (termp != NULL)
        tcsetattr(*slave, TCSAFLUSH, termp);
    if (winp != NULL)
        ioctl(*slave, TIOCSWINSZ, winp);

    return 0;
}

static int
_internal_login_tty(int fd, const char *path,
        struct termios *termp, struct winsize *winp)
{
    setsid();

    if (_internal_get_tty(&fd, path, termp, winp, 1) != 0)
        return -1;

    dup2(fd, 0);
    dup2(fd, 1);
    dup2(fd, 2);
    if (fd > 2)
        close(fd);
    return 0;

}

int
openpty(int *amaster, int *aslave, char *name,
        struct termios *termp, struct winsize *winp)
{
    char *path = NULL;
    int master = -1, slave = -1;

    if (amaster == NULL || aslave == NULL)
        return -1;

    if (_internal_get_pty(&master, &path) != 0)
        goto out;
    if (_internal_get_tty(&slave, path, termp, winp, 0) != 0)
        goto out;
    if (name != NULL)
        strcpy(name, path);

    *amaster = master;
    *aslave = slave;
    return 0;

out:
    if (master != -1)
        close(master);
    if (slave != -1)
        close(slave);
    return -1;
}

int
forkpty(int *amaster, char *name,
        struct termios *termp, struct winsize *winp)
{
    char *path;
    int master = -1;
    pid_t pid;

    if (amaster == NULL)
        return -1;

    if (_internal_get_pty(&master, &path) != 0)
        goto out;
    if (name != NULL)
        strcpy(name, path);

    if ((pid = fork()) == -1)
        goto out;
    if (pid == 0) {
        close(master);

        if (_internal_login_tty(-1, path, termp, winp) != 0)
            _exit(EXIT_FAILURE);

        return 0;
    }

    *amaster = master;
    return pid;

out:
    if (master != -1)
        close(master);
    return -1;
}

int
login_tty(int fd)
{
    return _internal_login_tty(fd, NULL, NULL, NULL);
}
