from distutils.core import setup, Extension

setup(name='init_extension_module',
      version='0.0',
      description='',
      ext_modules=[
          Extension('init_extension_module.__init__',
                    sources=['module.c'])
      ]
)
