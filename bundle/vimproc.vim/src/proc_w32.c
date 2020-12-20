/*-----------------------------------------------------------------------------
 * Copyright (c) 2006 Yukihiro Nakadaira - <yukihiro.nakadaira at gmail.com> original version(vimproc)
 * Copyright (c) 2009 Shougo Matsushita  - <Shougo.Matsu at gmail.com> modified version
 *
 * License: MIT license
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *---------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <errno.h>
#include <stdarg.h>
#include <ctype.h>
#include <io.h>

/* For GetConsoleWindow() for Windows 2000 or later. */
#ifndef WINVER
#define WINVER        0x0500
#endif
#ifndef _WIN32_WINNT
#define _WIN32_WINNT  0x0500
#endif

#include <windows.h>
#include <winbase.h>
#include <shellapi.h>
#if 0
# include <winsock2.h>
#endif
#define _POSIX_
#include <fcntl.h>
#include <io.h>

const int debug = 0;

#ifdef _MSC_VER
# define EXPORT __declspec(dllexport)
#else
# define EXPORT
#endif

#ifdef _MSC_VER
# if _MSC_VER < 1900
#  define snprintf _snprintf
# endif
# if _MSC_VER < 1400
#  define vsnprintf _vsnprintf
# endif
#endif

#include "vimstack.c"

#define lengthof(arr)   (sizeof(arr) / sizeof((arr)[0]))

/* API */
EXPORT const char *vp_dlopen(char *args);      /* [handle] (path) */
EXPORT const char *vp_dlclose(char *args);     /* [] (handle) */
EXPORT const char *vp_dlversion(char *args);     /* [version] () */

EXPORT const char *vp_file_open(char *args);   /* [fd] (path, flags, mode) */
EXPORT const char *vp_file_close(char *args);  /* [] (fd) */
EXPORT const char *vp_file_read(char *args);   /* [eof, hd] (fd, cnt, timeout) */
EXPORT const char *vp_file_write(char *args);  /* [nleft] (fd, timeout, hd) */

EXPORT const char *vp_pipe_open(char *args);   /* [pid, [fd] * npipe]
                                                  (npipe, argc, [argv]) */
EXPORT const char *vp_pipe_close(char *args);  /* [] (fd) */
EXPORT const char *vp_pipe_read(char *args);   /* [eof, hd] (fd, cnt, timeout) */
EXPORT const char *vp_pipe_write(char *args);  /* [nleft] (fd, timeout, hd) */

EXPORT const char *vp_pty_open(char *args);    /* [pid, fd, ttyname]
                                                  (width, height, argc, [argv]) */
EXPORT const char *vp_pty_close(char *args);   /* [] (fd) */
EXPORT const char *vp_pty_read(char *args);    /* [eof, hd] (fd, cnt, timeout) */
EXPORT const char *vp_pty_write(char *args);   /* [nleft] (fd, timeout, hd) */
EXPORT const char *vp_pty_get_winsize(char *args); /* [width, height] (fd) */
EXPORT const char *vp_pty_set_winsize(char *args); /* [] (fd, width, height) */

EXPORT const char *vp_kill(char *args);        /* [] (pid, sig) */
EXPORT const char *vp_waitpid(char *args);     /* [cond, status] (pid) */
EXPORT const char *vp_close_handle(char *args); /* [] (fd) */

EXPORT const char *vp_socket_open(char *args); /* [socket] (host, port) */
EXPORT const char *vp_socket_close(char *args);/* [] (socket) */
EXPORT const char *vp_socket_read(char *args); /* [eof, hd] (socket, cnt, timeout) */
EXPORT const char *vp_socket_write(char *args);/* [nleft] (socket, hd, timeout) */

EXPORT const char *vp_host_exists(char *args); /* [int] (host) */

EXPORT const char *vp_decode(char *args);      /* [decoded_str] (encode_str) */

EXPORT const char *vp_open(char *args);      /* [] (path) */
EXPORT const char *vp_readdir(char *args);  /* [files] (dirname) */


EXPORT const char * vp_delete_trash(char *args);  /* [int] (filename) */

EXPORT const char *vp_get_signals(char *args); /* [signals] () */

static BOOL ExitRemoteProcess(HANDLE hProcess, UINT_PTR uExitCode);

/* --- */

#define VP_BUFSIZE      (65536)
#define VP_READ_BUFSIZE (VP_BUFSIZE - (VP_HEADER_SIZE + 1) * 2 - 1)

static LPWSTR
utf8_to_utf16(const char *str)
{
    LPWSTR buf;
    int len;

    len = MultiByteToWideChar(CP_UTF8, 0, str, -1, NULL, 0);
    if (len == 0)
        return NULL;
    buf = malloc(sizeof(WCHAR) * (len + 1));
    if (buf == NULL) {
        SetLastError(ERROR_NOT_ENOUGH_MEMORY);
        return NULL;
    }
    MultiByteToWideChar(CP_UTF8, 0, str, -1, buf, len);
    buf[len] = 0;
    return buf;
}

static char *
utf16_to_utf8(LPCWSTR wstr)
{
    char *buf;
    int len;

    len = WideCharToMultiByte(CP_UTF8, 0, wstr, -1, NULL, 0, NULL, NULL);
    if (len == 0)
        return NULL;
    buf = malloc(sizeof(char) * (len + 1));
    if (buf == NULL) {
        SetLastError(ERROR_NOT_ENOUGH_MEMORY);
        return NULL;
    }
    WideCharToMultiByte(CP_UTF8, 0, wstr, -1, buf, len, NULL, NULL);
    buf[len] = 0;
    return buf;
}

static const char *
lasterror()
{
    static char lpMsgBuf[512];
    WCHAR buf[512];
    char *p;

    FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
            NULL, GetLastError(), 0,
            buf, lengthof(buf), NULL);
    p = utf16_to_utf8(buf);
    if (p == NULL)
        return NULL;
    lstrcpyn(lpMsgBuf, p, lengthof(lpMsgBuf));
    free(p);
    return lpMsgBuf;
}

#define open _open
#define close _close
#define read _read
#define write _write
#define lseek _lseek

static vp_stack_t _result = VP_STACK_NULL;

const char *
vp_dlopen(char *args)
{
    vp_stack_t stack;
    char *path;
    LPWSTR pathw;
    HINSTANCE handle;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &path));
    VP_RETURN_IF_FAIL(vp_stack_reserve(&_result, VP_BUFSIZE));

    pathw = utf8_to_utf16(path);
    if (pathw == NULL)
        return lasterror();
    handle = LoadLibraryW(pathw);
    free(pathw);
    if (handle == NULL)
        return lasterror();
    vp_stack_push_num(&_result, "%p", handle);
    return vp_stack_return(&_result);
}

const char *
vp_dlclose(char *args)
{
    vp_stack_t stack;
    HINSTANCE handle;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%p", &handle));

    if (!FreeLibrary(handle))
        return lasterror();
    vp_stack_free(&_result);
    return NULL;
}

const char *
vp_dlversion(char *args)
{
    vp_stack_push_num(&_result, "%2d%02d", 9, 3);
    return vp_stack_return(&_result);
}

static int
str_to_oflag(const char *flags)
{
    int oflag = 0;

    if (strchr("rwa", flags[0])) {
        if (strchr(flags, '+')) {
            oflag = _O_RDWR;
        } else {
            oflag = flags[0] == 'r' ? _O_RDONLY : _O_WRONLY;
        }
        if (flags[0] == 'w' || flags[0] == 'a') {
            oflag |= _O_CREAT | (flags[0] == 'w' ? _O_TRUNC : _O_APPEND);
        }
#define VP_CHR_TO_OFLAG(_c, _f) do { \
    if (strchr(flags, (_c))) { oflag |= _ ## _f; } \
} while (0)

#ifdef _O_EXCL
        VP_CHR_TO_OFLAG('x', O_EXCL);
#endif
#ifdef _O_CLOEXEC
        VP_CHR_TO_OFLAG('e', O_CLOEXEC);
#endif
#ifdef _O_BINARY
        VP_CHR_TO_OFLAG('b', O_BINARY);
#endif
#ifdef _O_TEXT
        VP_CHR_TO_OFLAG('t', O_TEXT);
#endif
#ifdef _O_SEQUENTIAL
        VP_CHR_TO_OFLAG('S', O_SEQUENTIAL);
#endif
#ifdef _O_RANDOM
        VP_CHR_TO_OFLAG('R', O_RANDOM);
#endif

#undef VP_CHR_TO_OFLAG
    } else {
        if (strstr(flags, "O_RDONLY")) {
            oflag = _O_RDONLY;
        } else if (strstr(flags, "O_WRONLY")) {
            oflag = _O_WRONLY;
        } else if (strstr(flags, "O_RDWR")) {
            oflag = _O_RDWR;
        } else {
            return -1;
        }
#define VP_STR_TO_OFLAG(_f) do { \
    if (strstr(flags, #_f)) { oflag |= _ ## _f; } \
} while (0)

        VP_STR_TO_OFLAG(O_APPEND);
        VP_STR_TO_OFLAG(O_CREAT);
        VP_STR_TO_OFLAG(O_TRUNC);
#ifdef _O_EXCL
        VP_STR_TO_OFLAG(O_EXCL);
#endif
#ifdef _O_NONBLOCK
        VP_STR_TO_OFLAG(O_NONBLOCK);
#endif
#ifdef _O_SHLOCK
        VP_STR_TO_OFLAG(O_SHLOCK);
#endif
#ifdef _O_EXLOCK
        VP_STR_TO_OFLAG(O_EXLOCK);
#endif
#ifdef _O_DIRECT
        VP_STR_TO_OFLAG(O_DIRECT);
#endif
#ifdef _O_FSYNC
        VP_STR_TO_OFLAG(O_FSYNC);
#endif
#ifdef _O_NOFOLLOW
        VP_STR_TO_OFLAG(O_NOFOLLOW);
#endif
#ifdef _O_TEMPORARY
        VP_STR_TO_OFLAG(O_TEMPORARY);
#endif
#ifdef _O_RANDOM
        VP_STR_TO_OFLAG(O_RANDOM);
#endif
#ifdef _O_SEQUENTIAL
        VP_STR_TO_OFLAG(O_SEQUENTIAL);
#endif
#ifdef _O_BINARY
        VP_STR_TO_OFLAG(O_BINARY);
#endif
#ifdef _O_TEXT
        VP_STR_TO_OFLAG(O_TEXT);
#endif
#ifdef _O_INHERIT
        VP_STR_TO_OFLAG(O_INHERIT);
#endif
#ifdef _O_SHORT_LIVED
        VP_STR_TO_OFLAG(O_SHORT_LIVED);
#endif

#undef VP_STR_TO_OFLAG
    }

    return oflag;
}

const char *
vp_file_open(char *args)
{
    vp_stack_t stack;
    char *path;
    LPWSTR pathw;
    char *flags;
    int mode;  /* used when flags have O_CREAT */
    int oflag = 0;
    int fd;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &path));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &flags));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &mode));

    oflag = str_to_oflag(flags);
    if (oflag == -1)
        return vp_stack_return_error(&_result, "open flag error.");

    pathw = utf8_to_utf16(path);
    if (pathw == NULL)
        return lasterror();

    fd = _wopen(pathw, oflag, mode);
    free(pathw);
    if (fd == -1) {
        return vp_stack_return_error(&_result, "open() error: %s",
                strerror(errno));
    }
    if (oflag & O_APPEND) {
        /* Note: Windows7 ignores O_APPEND flag. why? */
        lseek(fd, 0, SEEK_END);
    }
    vp_stack_push_num(&_result, "%d", fd);
    return vp_stack_return(&_result);
}

const char *
vp_file_close(char *args)
{
    vp_stack_t stack;
    int fd;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &fd));

    if (close(fd) == -1)
        return vp_stack_return_error(&_result, "close() error: %s",
                strerror(errno));
    return NULL;
}

const char *
vp_file_read(char *args)
{
    vp_stack_t stack;
    int fd;
    int cnt;
    int timeout;
    DWORD ret;
    int n;
    char *buf;
    char *eof;
    unsigned int size = 0;
    HANDLE hFile;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &fd));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &cnt));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &timeout));

    if (cnt < 0 || VP_READ_BUFSIZE < cnt) {
        cnt = VP_READ_BUFSIZE;
    }

    /* initialize buffer */
    _result.top = _result.buf;
    vp_stack_push_num(&_result, "%d", 0);   /* set eof to 0 */
    eof = _result.top - 1;
    buf = _result.top;
    *(buf++) = VP_EOV;
    buf += VP_HEADER_SIZE;

    hFile = (HANDLE)_get_osfhandle(fd);
    while (cnt > 0) {
        ret = WaitForSingleObject(hFile, timeout);
        if (ret == WAIT_FAILED) {
            return vp_stack_return_error(&_result, "WaitForSingleObject() error: %s",
                    lasterror());
        } else if (ret == WAIT_TIMEOUT) {
            /* timeout */
            break;
        }
        n = read(fd, buf, cnt);
        if (n == -1) {
            return vp_stack_return_error(&_result, "read() error: %s",
                    strerror(errno));
        } else if (n == 0) {
            /* eof */
            *eof = '1';
            break;
        }
        /* decrease stack top for concatenate. */
        cnt -= n;
        buf += n;
        size += n;
        /* try read more bytes without waiting */
        timeout = 0;
    }
    vp_encode_size(size, _result.top + 1);
    _result.top = buf;
    return vp_stack_return(&_result);
}

const char *
vp_file_write(char *args)
{
    vp_stack_t stack;
    int fd;
    char *buf;
    size_t size;
    int timeout;
    size_t nleft;
    DWORD ret;
    int n;
    HANDLE hFile;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &fd));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &timeout));

    size = vp_decode_size(stack.top);
    buf = stack.top + VP_HEADER_SIZE;

    nleft = 0;
    hFile = (HANDLE)_get_osfhandle(fd);
    while (nleft < size) {
        ret = WaitForSingleObject(hFile, timeout);
        if (ret == WAIT_FAILED) {
            return vp_stack_return_error(&_result, "WaitForSingleObject() error: %s",
                    lasterror());
        } else if (ret == WAIT_TIMEOUT) {
            /* timeout */
            break;
        }
        n = write(fd, buf + nleft, (unsigned int)(size - nleft));
        if (n == -1) {
            return vp_stack_return_error(&_result, "write() error: %s",
                    strerror(errno));
        }
        nleft += n;
        /* try write more bytes without waiting */
        timeout = 0;
    }
    vp_stack_push_num(&_result, "%u", nleft);
    return vp_stack_return(&_result);
}

/*
 * http://support.microsoft.com/kb/190351/
 */
const char *
vp_pipe_open(char *args)
{
#define VP_GOTO_ERROR(_fmt) do { errfmt = (_fmt); goto error; } while(0)
#define VP_DUP_HANDLE(hIn, phOut, inherit)                  \
        if (!DuplicateHandle(GetCurrentProcess(), hIn,      \
                    GetCurrentProcess(), phOut,             \
                    0, inherit, DUPLICATE_SAME_ACCESS)) {   \
            VP_GOTO_ERROR("DuplicateHandle() error: %s");   \
        }
    vp_stack_t stack;
    int npipe, hstdin, hstderr, hstdout;
    char *errfmt;
    const char *errmsg;
    char *cmdline;
    LPWSTR cmdlinew;
    HANDLE hInputWrite = INVALID_HANDLE_VALUE, hInputRead = INVALID_HANDLE_VALUE;
    HANDLE hOutputWrite = INVALID_HANDLE_VALUE, hOutputRead = INVALID_HANDLE_VALUE;
    HANDLE hErrorWrite = INVALID_HANDLE_VALUE, hErrorRead = INVALID_HANDLE_VALUE;
    SECURITY_ATTRIBUTES sa;
    PROCESS_INFORMATION pi;
    STARTUPINFOW si;
    BOOL ret;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &npipe));
    if (npipe != 2 && npipe != 3)
        return vp_stack_return_error(&_result, "npipe range error");
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &hstdin));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &hstdout));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &hstderr));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &cmdline));

    sa.nLength = sizeof(SECURITY_ATTRIBUTES);
    sa.lpSecurityDescriptor = NULL;
    sa.bInheritHandle = TRUE;

    if (hstdin) {
        /* Get handle. */
        VP_DUP_HANDLE((HANDLE)_get_osfhandle(hstdin), &hInputRead, TRUE);
    } else {
        HANDLE hInputWriteTmp;

        /* Create pipe. */
        if (!CreatePipe(&hInputRead, &hInputWrite, &sa, 0))
            VP_GOTO_ERROR("CreatePipe() error: %s");

        VP_DUP_HANDLE(hInputWrite, &hInputWriteTmp, FALSE);
        CloseHandle(hInputWrite);
        hInputWrite = hInputWriteTmp;
    }

    if (hstdout) {
        /* Get handle. */
        VP_DUP_HANDLE((HANDLE)_get_osfhandle(hstdout), &hOutputWrite, TRUE);
    } else {
        HANDLE hOutputReadTmp;

        /* Create pipe. */
        if (!CreatePipe(&hOutputRead, &hOutputWrite, &sa, 0))
            VP_GOTO_ERROR("CreatePipe() error: %s");

        VP_DUP_HANDLE(hOutputRead, &hOutputReadTmp, FALSE);
        CloseHandle(hOutputRead);
        hOutputRead = hOutputReadTmp;
    }

    if (npipe == 2) {
        VP_DUP_HANDLE(hOutputWrite, &hErrorWrite, TRUE);
    } else {
        if (hstderr) {
            /* Get handle. */
            VP_DUP_HANDLE((HANDLE)_get_osfhandle(hstderr), &hErrorWrite, TRUE);
        } else {
            HANDLE hErrorReadTmp;

            /* Create pipe. */
            if (!CreatePipe(&hErrorRead, &hErrorWrite, &sa, 0))
                VP_GOTO_ERROR("CreatePipe() error: %s");

            VP_DUP_HANDLE(hErrorRead, &hErrorReadTmp, FALSE);
            CloseHandle(hErrorRead);
            hErrorRead = hErrorReadTmp;
        }
    }

    ZeroMemory(&si, sizeof(STARTUPINFOW));
    si.cb = sizeof(STARTUPINFOW);
    si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_SHOW;
    si.hStdInput = hInputRead;
    si.hStdOutput = hOutputWrite;
    si.hStdError = hErrorWrite;

    cmdlinew = utf8_to_utf16(cmdline);
    if (cmdlinew == NULL)
        VP_GOTO_ERROR("utf8_to_utf16() error: %s");

    ret = CreateProcessW(NULL, cmdlinew, NULL, NULL, TRUE,
                        CREATE_NO_WINDOW, NULL, NULL, &si, &pi);
    free(cmdlinew);
    if (!ret)
        VP_GOTO_ERROR("CreateProcess() error: %s");

    CloseHandle(pi.hThread);

    CloseHandle(hInputRead);
    CloseHandle(hOutputWrite);
    CloseHandle(hErrorWrite);

    vp_stack_push_num(&_result, "%p", pi.hProcess);
    vp_stack_push_num(&_result, "%d", hstdin ?
            0 : _open_osfhandle((size_t)hInputWrite, 0));
    vp_stack_push_num(&_result, "%d", hstdout ?
            0 : _open_osfhandle((size_t)hOutputRead, _O_RDONLY));
    if (npipe == 3)
        vp_stack_push_num(&_result, "%d", hstderr ?
                0 : _open_osfhandle((size_t)hErrorRead, _O_RDONLY));
    return vp_stack_return(&_result);

error:
    errmsg = lasterror();
    if (hInputWrite  != INVALID_HANDLE_VALUE) CloseHandle(hInputWrite);
    if (hInputRead   != INVALID_HANDLE_VALUE) CloseHandle(hInputRead);
    if (hOutputWrite != INVALID_HANDLE_VALUE) CloseHandle(hOutputWrite);
    if (hOutputRead  != INVALID_HANDLE_VALUE) CloseHandle(hOutputRead);
    if (hErrorWrite  != INVALID_HANDLE_VALUE) CloseHandle(hErrorWrite);
    if (hErrorRead   != INVALID_HANDLE_VALUE) CloseHandle(hErrorRead);
    return vp_stack_return_error(&_result, errfmt, errmsg);
#undef VP_DUP_HANDLE
#undef VP_GOTO_ERROR
}

const char *
vp_pipe_close(char *args)
{
    vp_stack_t stack;
    int fd;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &fd));

    if (close(fd))
        return vp_stack_return_error(&_result, "close() error: %s",
                lasterror());
    return NULL;
}

const char *
vp_pipe_read(char *args)
{
    vp_stack_t stack;
    int fd;
    int cnt;
    int timeout;
    DWORD n;
    DWORD err;
    char *buf;
    char *eof;
    unsigned int size = 0;
    HANDLE hPipe;
    DWORD tcstart;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &fd));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &cnt));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &timeout));

    if (cnt < 0 || VP_READ_BUFSIZE < cnt) {
        cnt = VP_READ_BUFSIZE;
    }

    /* initialize buffer */
    _result.top = _result.buf;
    vp_stack_push_num(&_result, "%d", 0);   /* set eof to 0 */
    eof = _result.top - 1;
    buf = _result.top;
    *(buf++) = VP_EOV;
    buf += VP_HEADER_SIZE;

    hPipe = (HANDLE)_get_osfhandle(fd);
    tcstart = GetTickCount();
    while (cnt > 0) {
        if (!PeekNamedPipe(hPipe, NULL, 0, NULL, &n, NULL)) {
            /* can be ERROR_HANDLE_EOF? */
            err = GetLastError();
            if (err == 0 || err == ERROR_BROKEN_PIPE) {
                /* error or eof */
                if (err == ERROR_BROKEN_PIPE) {
                    *eof = '1';
                }
                break;
            }
            return vp_stack_return_error(&_result, "PeekNamedPipe() error: %08X %s",
                    err, lasterror());
        } else if (n == 0) {
            if (GetTickCount() - tcstart >= timeout) {
                break;
            }
            Sleep(1);
            continue;
        }
        n = read(fd, buf, cnt);
        if (n == -1) {
            return vp_stack_return_error(&_result, "read() error: %s",
                    strerror(errno));
        }
        /* decrease stack top for concatenate. */
        cnt -= n;
        buf += n;
        size += n;
        /* try read more bytes without waiting */
        timeout = 0;
    }
    vp_encode_size(size, _result.top + 1);
    _result.top = buf;
    return vp_stack_return(&_result);
}

const char *
vp_pipe_write(char *args)
{
    return vp_file_write(args);
}

const char *
vp_pty_open(char *args)
{
    return "vp_pty_open() is not available";
}

const char *
vp_pty_close(char *args)
{
    return "vp_pty_close() is not available";
}

const char *
vp_pty_read(char *args)
{
    return "vp_pty_read() is not available";
}

const char *
vp_pty_write(char *args)
{
    return "vp_pty_write() is not available";
}

const char *
vp_pty_get_winsize(char *args)
{
    return "vp_pty_get_winsize() is not available";
}

const char *
vp_pty_set_winsize(char *args)
{
    return "vp_pty_set_winsize() is not available";
}

const char *
vp_kill(char *args)
{
    vp_stack_t stack;
    HANDLE handle;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%p", &handle));

    /*if (!TerminateProcess(handle, 2) || !CloseHandle(handle))*/
        /*return vp_stack_return_error(&_result, "kill() error: %s",*/
                /*lasterror());*/
    if (!ExitRemoteProcess(handle, 2)) {
        return vp_stack_return_error(&_result, "kill() error: %s",
                lasterror());
    }

    vp_stack_push_num(&_result, "%d", 0);
    return vp_stack_return(&_result);
}

/* Improved kill function. */
/* http://homepage3.nifty.com/k-takata/diary/2009-05.html */
static BOOL ExitRemoteProcess(HANDLE hProcess, UINT_PTR uExitCode)
{
    LPTHREAD_START_ROUTINE pfnExitProcess =
        (LPTHREAD_START_ROUTINE) GetProcAddress(
                GetModuleHandle("kernel32.dll"), "ExitProcess");
    if ((hProcess != NULL) && (pfnExitProcess != NULL)) {
        HANDLE hThread = CreateRemoteThread(hProcess, NULL, 0,
                pfnExitProcess, (LPVOID) uExitCode, 0, NULL);
        if (hThread != NULL) {
            CloseHandle(hThread);
            return TRUE;
        }
    }
    return FALSE;
}

const char *
vp_waitpid(char *args)
{
    vp_stack_t stack;
    HANDLE handle;
    DWORD exitcode;
    DWORD ret;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%p", &handle));

    ret = WaitForSingleObject(handle, 0);
    if (ret == WAIT_OBJECT_0) {
        /* The process has been exited. */
        if (!GetExitCodeProcess(handle, &exitcode)) {
            return vp_stack_return_error(&_result,
                    "GetExitCodeProcess() error: %s", lasterror());
        }
    } else if (ret == WAIT_TIMEOUT) {
        exitcode = STILL_ACTIVE;
    } else {
        return vp_stack_return_error(&_result,
                "WaitForSingleObject() error: %s", lasterror());
    }

    vp_stack_push_str(&_result, (ret == WAIT_TIMEOUT) ? "run" : "exit");
    vp_stack_push_num(&_result, "%u", exitcode);
    return vp_stack_return(&_result);
}

const char *
vp_close_handle(char *args)
{
    vp_stack_t stack;
    HANDLE handle;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%p", &handle));

    if (!CloseHandle(handle)) {
        return vp_stack_return_error(&_result,
                "CloseHandle() error: %s", lasterror());
    }
    return NULL;
}

/*
 * This is based on socket.diff.gz written by Yasuhiro Matsumoto.
 * see: http://marc.theaimsgroup.com/?l=vim-dev&m=105289857008664&w=2
 */
static int sockets_number = 0;

static int
detain_winsock()
{
    WSADATA wsadata;
    int res = 0;

    if (sockets_number == 0) {  /* Need startup process. */
        res = WSAStartup(MAKEWORD(2, 0), &wsadata);
        if(res) return res;   /* Fail */
    }
    ++sockets_number;
    return res;
}

static int
release_winsock()
{
    int res = 0;

    if (sockets_number != 0) {
        res = WSACleanup();
        if(res) return res;   /* Fail */

        --sockets_number;
    }
    return res;
}


const char *
vp_socket_open(char *args)
{
    vp_stack_t stack;
    char *host;
    char *port;
    int port_nr;
    int n;
    unsigned short nport;
    int sock;
    struct sockaddr_in sockaddr;
    struct hostent *hostent;
    struct servent *servent;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &host));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &port));

    if (detain_winsock()) {
        return vp_stack_return_error(&_result, "WSAStartup() error: %s",
            lasterror());
    }

    if (sscanf(port, "%d%n", &port_nr, &n) == 1 && port[n] == '\0') {
        nport = htons((u_short)port_nr);
    } else {
        servent = getservbyname(port, NULL);
        if (servent == NULL)
            return vp_stack_return_error(&_result, "getservbyname() error: %s",
                    port);
        nport = servent->s_port;
    }

    sock = (int)socket(PF_INET, SOCK_STREAM, 0);
    hostent = gethostbyname(host);
    sockaddr.sin_family = AF_INET;
    sockaddr.sin_port = nport;
    sockaddr.sin_addr = *((struct in_addr*)*hostent->h_addr_list);

    if (connect(sock, (struct sockaddr*)&sockaddr, sizeof(struct sockaddr_in))
            == -1) {
        return vp_stack_return_error(&_result, "connect() error: %s",
                strerror(errno));
    }

    vp_stack_push_num(&_result, "%d", sock);
    return vp_stack_return(&_result);
}

const char *
vp_socket_close(char *args)
{
    vp_stack_t stack;
    int sock;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &sock));

    if (closesocket(sock) == SOCKET_ERROR) {
        return vp_stack_return_error(&_result, "closesocket() error: %d",
                WSAGetLastError());
    }
    release_winsock();
    return NULL;
}

const char *
vp_socket_read(char *args)
{
    vp_stack_t stack;
    int sock;
    int cnt;
    int timeout;
    struct timeval tv;
    int n;
    char *buf;
    char *eof;
    unsigned int size = 0;
    fd_set fdset;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &sock));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &cnt));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &timeout));
    tv.tv_sec = timeout / 1000;
    tv.tv_usec = (timeout - tv.tv_sec * 1000) * 1000;

    if (cnt < 0 || VP_READ_BUFSIZE < cnt) {
        cnt = VP_READ_BUFSIZE;
    }

    /* initialize buffer */
    _result.top = _result.buf;
    vp_stack_push_num(&_result, "%d", 0);   /* set eof to 0 */
    eof = _result.top - 1;
    buf = _result.top;
    *(buf++) = VP_EOV;
    buf += VP_HEADER_SIZE;

    while (cnt > 0) {
        FD_ZERO(&fdset);
        FD_SET((unsigned)sock, &fdset);

        n = select(0, &fdset, NULL, NULL, (timeout == -1) ? NULL : &tv);
        if (n == SOCKET_ERROR) {
            return vp_stack_return_error(&_result, "select() error: %d",
                    WSAGetLastError());
        } else if (n == 0) {
            /* timeout */
            break;
        }
        n = recv(sock, buf, cnt, 0);
        if (n == -1) {
            return vp_stack_return_error(&_result, "recv() error: %s",
                    strerror(errno));
        } else if (n == 0) {
            /* eof */
            *eof = '1';
            break;
        }
        /* decrease stack top for concatenate. */
        cnt -= n;
        buf += n;
        size += n;
        /* try read more bytes without waiting */
        timeout = 0;
        tv.tv_sec = 0;
        tv.tv_usec = 0;
    }
    vp_encode_size(size, _result.top + 1);
    _result.top = buf;
    return vp_stack_return(&_result);
}

const char *
vp_socket_write(char *args)
{
    vp_stack_t stack;
    int sock;
    char *buf;
    size_t size;
    int timeout;
    struct timeval tv;
    size_t nleft;
    int n;
    fd_set fdset;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &sock));
    VP_RETURN_IF_FAIL(vp_stack_pop_num(&stack, "%d", &timeout));
    tv.tv_sec = timeout / 1000;
    tv.tv_usec = (timeout - tv.tv_sec * 1000) * 1000;

    size = vp_decode_size(stack.top);
    buf = stack.top + VP_HEADER_SIZE;

    nleft = 0;
    while (nleft < size) {
        FD_ZERO(&fdset);
        FD_SET((unsigned)sock, &fdset);

        n = select(0, NULL, &fdset, NULL, (timeout == -1) ? NULL : &tv);
        if (n == SOCKET_ERROR) {
            return vp_stack_return_error(&_result, "select() error: %d",
                    WSAGetLastError());
        } else if (n == 0) {
            /* timeout */
            break;
        }
        n = send(sock, buf + nleft, (int)(size - nleft), 0);
        if (n == -1)
            return vp_stack_return_error(&_result, "send() error: %s",
                    strerror(errno));
        nleft += n;
        /* try write more bytes without waiting */
        timeout = 0;
        tv.tv_sec = 0;
        tv.tv_usec = 0;
    }
    vp_stack_push_num(&_result, "%u", nleft);
    return vp_stack_return(&_result);
}


/*
 * Added by Richard Emberson
 * Check to see if a host exists.
 */
const char *
vp_host_exists(char *args)
{
    vp_stack_t stack;
    char *host;
    struct hostent *hostent;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &host));

    if(detain_winsock())
    {
        return vp_stack_return_error(&_result, "WSAStartup() error: %s",
            lasterror());
    }
    hostent = gethostbyname(host);
    release_winsock();

    if (hostent) {
        vp_stack_push_num(&_result, "%d", 1);
    } else {
        vp_stack_push_num(&_result, "%d", 0);
    }

    return vp_stack_return(&_result);
}


/* Referenced from */
/* http://www.syuhitu.org/other/dir.html */
const char *
vp_readdir(char *args)
{
    vp_stack_t stack;
    char *dirname;
    LPWSTR dirnamew;
    WCHAR buf[1024];

    WIN32_FIND_DATAW fd;
    HANDLE h;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &dirname));

    dirnamew = utf8_to_utf16(dirname);
    if (dirnamew == NULL)
        return lasterror();
    _snwprintf(buf, lengthof(buf), L"%s\\*", dirnamew);
    buf[lengthof(buf) - 1] = 0;

    /* Get handle. */
    h = FindFirstFileExW(buf,
#if WINVER >= 0x601
            FindExInfoBasic,
#else
            FindExInfoStandard,
#endif
            &fd,
            FindExSearchNameMatch, NULL, 0
    );

    if (h == INVALID_HANDLE_VALUE) {
        free(dirnamew);
        return vp_stack_return_error(&_result,
                "FindFirstFileEx() error: %s",
                lasterror());
    }

    do {
        if (wcscmp(fd.cFileName, L".") && wcscmp(fd.cFileName, L"..")) {
            char *p;
            _snwprintf(buf, lengthof(buf), L"%s/%s", dirnamew, fd.cFileName);
            buf[lengthof(buf) - 1] = 0;
            p = utf16_to_utf8(buf);
            if (p) {
                vp_stack_push_str(&_result, p);
                free(p);
            }
        }
    } while (FindNextFileW(h, &fd));
    free(dirnamew);

    FindClose(h);
    return vp_stack_return(&_result);
}

const char *
vp_delete_trash(char *args)
{
    vp_stack_t stack;
    char *filename;
    LPWSTR filenamew;
    LPWSTR buf;
    size_t len;
    SHFILEOPSTRUCTW fs;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &filename));

    filenamew = utf8_to_utf16(filename);
    if (filenamew == NULL)
        return lasterror();

    len = wcslen(filenamew);

    buf = malloc(sizeof(WCHAR) * (len + 2));
    if (buf == NULL) {
        free(filenamew);
        return vp_stack_return_error(&_result, "malloc() error: %s",
                "Memory cannot allocate");
    }

    /* Copy filename + '\0\0' */
    wcscpy(buf, filenamew);
    buf[len + 1] = 0;
    free(filenamew);

    ZeroMemory(&fs, sizeof(SHFILEOPSTRUCTW));
    fs.hwnd = NULL;
    fs.wFunc = FO_DELETE;
    fs.pFrom = buf;
    fs.pTo = NULL;
    fs.fFlags = FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_NOERRORUI | FOF_SILENT;

    vp_stack_push_num(&_result, "%d", SHFileOperationW(&fs));

    free(buf);

    return vp_stack_return(&_result);
}

const char *
vp_open(char *args)
{
    vp_stack_t stack;
    char *path;
    LPWSTR pathw;
    size_t ret;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &path));

    pathw = utf8_to_utf16(path);
    if (pathw == NULL)
        return lasterror();

    ret = (size_t)ShellExecuteW(NULL, L"open", pathw, NULL, NULL, SW_SHOWNORMAL);
    free(pathw);
    if (ret < 32) {
        return vp_stack_return_error(&_result, "ShellExecute() error: %s",
                lasterror());
    }

    return NULL;
}

const char *
vp_decode(char *args)
{
    vp_stack_t stack;
    size_t len;
    char *str;
    char *p, *q;

    VP_RETURN_IF_FAIL(vp_stack_from_args(&stack, args));
    VP_RETURN_IF_FAIL(vp_stack_pop_str(&stack, &str));

    len = strlen(str);
    if (len % 2 != 0) {
        return "vp_decode: invalid data length";
    }

    VP_RETURN_IF_FAIL(vp_stack_reserve(&_result,
            (_result.top - _result.buf) + (len / 2) + sizeof(VP_EOV_STR)));

    for (p = str, q = _result.top; p < str + len; ) {
        char hb, lb;

        hb = CHR2XD[(int)*(p++)];
        lb = CHR2XD[(int)*(p++)];
        if (hb >= 0 && lb >= 0) {
            *(q++) = (char)((hb << 4) | lb);
        }
    }
    *(q++) = VP_EOV;
    *q = '\0';
    _result.top = q;

    return vp_stack_return(&_result);
}

const char *
vp_get_signals(char *args)
{
    const char *signames[] = {
        "SIGABRT",
        "SIGFPE",
        "SIGILL",
        "SIGINT",
        "SIGSEGV",
        "SIGTERM",
        "SIGALRM",
        "SIGCHLD",
        "SIGCONT",
        "SIGHUP",
        "SIGKILL",
        "SIGPIPE",
        "SIGQUIT",
        "SIGSTOP",
        "SIGTSTP",
        "SIGTTIN",
        "SIGTTOU",
        "SIGUSR1",
        "SIGUSR2"
    };
    size_t i;

    for (i = 0; i < lengthof(signames); ++i)
        vp_stack_push_num(&_result, "%s:%d", signames[i], i + 1);
    return vp_stack_return(&_result);
}

/*
 * vim:set sw=4 sts=4 et:
 */
