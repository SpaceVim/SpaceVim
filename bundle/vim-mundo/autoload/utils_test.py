import nose
from nose.tools import *
import mundo.diff as difflib

def test_one_line_diff():
  eq_(difflib.one_line_diff('', ''), [])
  eq_(difflib.one_line_diff('', 'a'), ['+a+'])
  eq_(difflib.one_line_diff('a', 'b'), ['-a-+b+'])
  eq_(difflib.one_line_diff('', 'a\nb\nc\n'), ['+a\nb\nc\n+'])
  eq_(difflib.one_line_diff('one\ntwo', 'two\nthree'), ['-one\n-', 'two', '+\nthree+'])
  eq_(difflib.one_line_diff('b\nd\ne\nf', 'm\nn\no\np\n'), ['-b-+m+', '\n', '-d-+n+', '\n', '-e-+o+', '\n', '-f-+p\n+'])
  eq_(difflib.one_line_diff('m\nd\ne\nf', 'moon\nn\no\np\n'), ['m', '+oon+', '\n', '-\n-+n+', '\n', '+o+', '\n', '+p\n+'])
  eq_(difflib.one_line_diff('m\nbagman', 'm\nbadger'), ['m\nba', '+d+', 'g', '-an-+er+'])
  eq_(difflib.one_line_diff('', '1234567890abcdefghij'), ['+1234567890abcdefghij+'])

def test_one_line_diff_str():
  eq_(difflib.one_line_diff_str('', ''), '')
  eq_(difflib.one_line_diff_str('one\ntwo', 'two\nthree'), '-one\\n-two+\\nt+')
  eq_(difflib.one_line_diff_str('m\nd\ne\nf', 'moon\nn\no\np\n'), 'm+oon+\\n-\\n-+n+')
  eq_(difflib.one_line_diff_str('m\nbagman', 'm\nbadger'), 'ba+d+g-an-+er+')
  # when the '+' is over the cuttoff, it should be appended:
  eq_(difflib.one_line_diff_str('', '1234567890abcdefghij'), '+1234567890abc+')
  eq_(difflib.one_line_diff_str('one\n\ntwo', 'one\n\ntwo\n\nthree\n\nfour'), 'wo+\\n\\nthree\\n+')
