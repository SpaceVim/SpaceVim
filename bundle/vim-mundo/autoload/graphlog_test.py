import nose
from nose.tools import *
from mock import patch
import mundo.graphlog as graphlog
from mundo.node import Nodes

@patch('mundo.util.vim')
def test_generate(mock_vim):
  eq_(graphlog.generate(
    False,
    0,
    1,
    2,
    False,
    Nodes() 
  ), [['o ', '[0] Original   ']])
