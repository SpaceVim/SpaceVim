#include "Python.h"

static struct PyModuleDef module = {
   PyModuleDef_HEAD_INIT,
   "init_extension_module",
   NULL,
   -1,
   NULL
};

PyMODINIT_FUNC PyInit_init_extension_module(void){
    PyObject *m = PyModule_Create(&module);
    PyModule_AddObject(m, "foo", Py_None);
    return m;
}
