/*  fakepoll.h */
/*  poll using select */
/*  Warning: a call to this poll() takes about 4K of stack space. */

/*  Greg Parker     gparker-web@sealiesoftware.com     December 2000 */
/*  This code is in the public domain and may be copied or modified without  */
/*  permission.  */

/*  Nico Raffato gparker-web@sealiesoftware.com     September 2009 */

/*  Updated Sep 2009:  */
/*  * fix crash when an fd is less than 0 */
/*  * don't set POLLIN or POLLOUT in revents if it wasn't requested  */
/*    in events (only happens when an fd is in the poll set twice) */

#ifndef _FAKE_POLL_H
#define _FAKE_POLL_H

#include <limits.h>
#include <sys/types.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>

#ifndef OPEN_MAX
  #define OPEN_MAX (sysconf(_SC_OPEN_MAX))
#endif

typedef struct pollfd {
    int fd;                         /* file desc to poll */
    short events;                   /* events of interest on fd */
    short revents;                  /* events that occurred on fd */
} pollfd_t;


/* poll flags */
#define POLLIN  0x0001
#define POLLOUT 0x0004
#define POLLERR 0x0008

/* synonyms */
#define POLLNORM POLLIN
#define POLLPRI POLLIN
#define POLLRDNORM POLLIN
#define POLLRDBAND POLLIN
#define POLLWRNORM POLLOUT
#define POLLWRBAND POLLOUT

/* ignored */
#define POLLHUP 0x0010
#define POLLNVAL 0x0020

int poll(struct pollfd *pollSet, int pollCount, int pollTimeout)
{
    struct timeval tv;
    struct timeval *tvp;
    fd_set readFDs, writeFDs, exceptFDs;
    fd_set *readp, *writep, *exceptp;
    struct pollfd *pollEnd, *p;
    int selected;
    int result;
    int maxFD;

    if (!pollSet) {
        pollEnd = NULL;
        readp = NULL;
        writep = NULL;
        exceptp = NULL;
        maxFD = 0;
    } else {
        pollEnd = pollSet + pollCount;
        readp = &readFDs;
        writep = &writeFDs;
        exceptp = &exceptFDs;

        FD_ZERO(readp);
        FD_ZERO(writep);
        FD_ZERO(exceptp);

        /*  Find the biggest fd in the poll set */
        maxFD = 0;
        for (p = pollSet; p < pollEnd; p++) {
            if (p->fd > maxFD) maxFD = p->fd;
        }

        if (maxFD >= OPEN_MAX) {
            /*  At least one fd is too big */
            errno = EINVAL;
            return -1;
        }

        /*  Transcribe flags from the poll set to the fd sets */
        for (p = pollSet; p < pollEnd; p++) {
            if (p->fd < 0) {
                /*  Negative fd checks nothing and always reports zero */
            } else {
                if (p->events & POLLIN)  FD_SET(p->fd, readp);
                if (p->events & POLLOUT) FD_SET(p->fd, writep);
                if (p->events != 0)      FD_SET(p->fd, exceptp);
                /*  POLLERR is never set coming in; poll() always reports errors */
                /*  But don't report if we're not listening to anything at all. */
            }
        }
    }

    /*  poll timeout is in milliseconds. Convert to struct timeval. */
    /*  poll timeout == -1 : wait forever : select timeout of NULL */
    /*  poll timeout == 0  : return immediately : select timeout of zero */
    if (pollTimeout >= 0) {
        tv.tv_sec = pollTimeout / 1000;
        tv.tv_usec = (pollTimeout % 1000) * 1000;
        tvp = &tv;
    } else {
        tvp = NULL;
    }

    selected = select(maxFD+1, readp, writep, exceptp, tvp);


    if (selected < 0) {
        /*  Error during select */
        result = -1;
    } else if (selected > 0) {
        /*  Select found something */
        /*  Transcribe result from fd sets to poll set. */
        /*  Also count the number of selected fds. poll returns the  */
        /*  number of ready fds; select returns the number of bits set. */
        int polled = 0;
        for (p = pollSet; p < pollEnd; p++) {
            p->revents = 0;
            if (p->fd < 0) {
                /*  Negative fd always reports zero */
            } else {
                if ((p->events & POLLIN)   &&  FD_ISSET(p->fd, readp)) {
                    p->revents |= POLLIN;
                }
                if ((p->events & POLLOUT)  &&  FD_ISSET(p->fd, writep)) {
                    p->revents |= POLLOUT;
                }
                if ((p->events != 0)       &&  FD_ISSET(p->fd, exceptp)) {
                    p->revents |= POLLERR;
                }

                if (p->revents) polled++;
            }
        }
        result = polled;
    } else {
        /*  selected == 0, select timed out before anything happened */
        /*  Clear all result bits and return zero. */
        for (p = pollSet; p < pollEnd; p++) {
            p->revents = 0;
        }
        result = 0;
    }

    return result;
}


#endif   /* _FAKE_POLL_H */
