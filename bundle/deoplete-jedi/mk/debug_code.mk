IMPORT_LOGGER := from logging import getLogger\nlogger = getLogger(__name__)
IMPORT_TIMEIT := from profiler import timeit
IMPORT_PYVMMONITOR := import sys\nsys.path.append("\/Applications\/PyVmMonitor.app\/Contents\/MacOS\/public_api")\nimport pyvmmonitor

SET_DEBUG_PREFIX := jedi_settings.cache_directory \= os.path.join\(cache_home, 'jedi'\)
SET_DEBUG := try:\n            from helper import set_debug\n            if self.vim.vars["deoplete\#enable_debug"]:\n                log_file \= self.vim.vars["deoplete\#sources\#jedi\#debug\#log_file"]\n                set_debug(logger, os.path.expanduser(log_file))\n        except Exception:\n            pass\n

TIMEIT_PREFIX := @timeit(logger, 
TIMEIT_SUFFIX := )
TIMEIT_GET_COMPLETE_POSITION := ${TIMEIT_PREFIX}"simple", [0.00003000, 0.00015000]${TIMEIT_SUFFIX}
TIMEIT_GATHER_CANDIDATES := ${TIMEIT_PREFIX}"simple", [0.10000000, 0.20000000]${TIMEIT_SUFFIX}

PYVMMONITOR_DECORATOR := @pyvmmonitor.profile_method()
