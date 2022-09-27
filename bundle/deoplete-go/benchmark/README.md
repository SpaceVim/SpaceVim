```bash
> python3 benchmark.py

Running json benchmarks...
Running simplejson benchmarks...
Running ujson benchmarks...
Running rapidjson benchmarks...

Results
=======

# filesize: 2248 byte
loads (fmt.json)
--------------------
json       0.00288 s
simplejson 0.00257 s
ujson      0.00327 s
rapidjson  0.00504 s

# filesize: 116347 byte
loads (syscall.json)
--------------------
json       0.16875 s
simplejson 0.15083 s
ujson      0.12698 s
rapidjson  0.15828 s

# filesize: 160808 byte
loads (gocode.json)
--------------------
json       0.22175 s
simplejson 0.18736 s
ujson      0.17142 s
rapidjson  0.20404 s

# filesize: 1768818 byte
loads (gocode-twice.json)
--------------------
json       2.94173 s
simplejson 2.60381 s
ujson      2.63998 s
rapidjson  3.08415 s

# filesize: 2248 byte
dumps (fmt.json)
--------------------
json       0.00347 s
simplejson 0.00430 s
ujson      0.00178 s
rapidjson  0.00305 s

# filesize: 116347 byte
dumps (syscall.json)
--------------------
json       0.21460 s
simplejson 0.25808 s
ujson      0.08036 s
rapidjson  0.06591 s

# filesize: 160808 byte
dumps (gocode.json)
--------------------
json       0.29153 s
simplejson 0.35043 s
ujson      0.14064 s
rapidjson  0.08929 s

# filesize: 1768818 byte
dumps (gocode-twice.json)
--------------------
json       3.56336 s
simplejson 3.97017 s
ujson      1.37770 s
rapidjson  1.09713 s

python3 benchmark.py  21.92s user 2.28s system 99% cpu 24.324 total
```
