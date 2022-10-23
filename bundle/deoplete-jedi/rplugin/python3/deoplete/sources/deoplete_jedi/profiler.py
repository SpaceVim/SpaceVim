import functools
import queue

try:
    import statistics
    stdev = statistics.stdev
    mean = statistics.mean
except ImportError:
    stdev = None

    def mean(li):
        return sum(li) / len(li)

try:
    import time
    clock = time.perf_counter
except Exception:
    import timeit
    clock = timeit.default_timer


class tfloat(float):
    color = 39

    def __str__(self):
        n = self * 1000
        return '\x1b[%dm%f\x1b[mms' % (self.color, n)


def profile(func):
    name = func.__name__
    samples = queue.deque(maxlen=5)

    @functools.wraps(func)
    def wrapper(self, *args, **kwargs):
        if not self.is_debug_enabled:
            return func(self, *args, **kwargs)
        start = clock()
        ret = func(self, *args, **kwargs)
        n = tfloat(clock() - start)

        if len(samples) < 2:
            m = 0
            d = 0
            n.color = 36
        else:
            m = mean(samples)
            if stdev:
                d = tfloat(stdev(samples))
            else:
                d = 0

            if n <= m + d:
                n.color = 32
            elif n > m + d * 2:
                n.color = 31
            else:
                n.color = 33
        samples.append(n)
        self.info('\x1b[34m%s\x1b[m t = %s, \u00b5 = %s, \u03c3 = %s)',
                  name, n, m, d)
        return ret
    return wrapper
