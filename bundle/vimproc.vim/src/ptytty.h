#ifndef VP_PTYTTY_H_
#define VP_PTYTTY_H_

#include <termios.h>

int openpty(int *, int *, char *, struct termios *, struct winsize *);
int forkpty(int *, char *, struct termios *, struct winsize *);
int login_tty(int);

#endif /* VP_PTYTTY_H_ */
