import pylab

# two gotos
#! ['module numpy']
import numpy

#! ['module random']
import numpy.random

#? ['array2string']
numpy.array2string

#? ['shape']
numpy.matrix().shape

#? ['random_integers']
pylab.random_integers

#? []
numpy.random_integers

#? ['random_integers']
numpy.random.random_integers
#? ['sample']
numpy.random.sample

import numpy
na = numpy.array([1,2])
#? ['shape']
na.shape

# shouldn't raise an error #29, jedi-vim
# doesn't return something, because matplotlib uses __import__
fig = pylab.figure()
#? 
fig.add_subplot
