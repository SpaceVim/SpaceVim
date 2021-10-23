import difflib
import itertools

# one line diff functions.
def one_line_diff_str(before,after,mx=15,pre=2):
    """
    Return a summary of the differences between two strings, concatenated.

    Parameters:

      before - string before.
      after  - after string.
      mx     - the max number of strings.
      pre    - number of characters to show before diff (context)

    Returns a string no longer than 'mx'.
    """
    old = one_line_diff(before,after)
    result = ''
    firstEl = True
    # TODO instead of using +addition+ and -subtraction- it'd be nice to be able
    # to highlight the change w/o requiring the +/- chars.
    for v in old:
        # if the first element doesn't have a change, then don't include it.
        v = escape_returns(v)
        if firstEl:
            firstEl = False
            # add in pre character context:
            if not (v.startswith('+') or v.startswith('-')) and result == '':
                v = v[-pre:]
        # when we're going to be bigger than our max limit, lets ensure that the
        # trailing +/- appears in the text:
        if len(result) + len(v) > mx:
            if v.startswith('+') or v.startswith('-'):
                result += v[:mx - len(result) - 1]
                result += v[0]
            break
        result += v
    return result

def escape_returns(result):
    return result.replace('\n','\\n').replace('\r','\\r').replace('\t','\\t')

def one_line_diff(before, after):
    """
    Return a summary of the differences between two arbitrary strings.

    Returns a list of strings, summarizing all the changes.
    """
    a, b, result = [], [], []
    for line in itertools.chain(itertools.islice(
        difflib.unified_diff(before.splitlines(),
                             after.splitlines()), 2, None), ['@@']):
        if line.startswith('@@'):
            result.extend(one_line_diff_raw('\n'.join(a), '\n'.join(b)))
            a, b = [], []
            continue
        if not line.startswith('+'):
            a.append(line[1:])
        if not line.startswith('-'):
            b.append(line[1:])
    if after.endswith('\n') and not before.endswith('\n'):
        if result:
            result[-1] = result[-1][:-1] + '\n+'
        else:
            result = ['+\n+']
    return result

def one_line_diff_raw(before,after):
  s = difflib.SequenceMatcher(None,before,after)
  results = []
  for tag, i1, i2, j1, j2 in s.get_opcodes():
    #print ("%7s a[%d:%d] (%s) b[%d:%d] (%s)" % (tag, i1, i2, before[i1:i2], j1, j2, after[j1:j2]))
    if tag == 'equal':
      _append_result(results,{
        'equal': after[j1:j2]
      })
    if tag == 'insert':
      _append_result(results,{
        'plus': after[j1:j2]
      })
    elif tag == 'delete':
      _append_result(results,{
        'minus': before[i1:i2]
      })
    elif tag == 'replace':
      _append_result(results,{
        'minus': before[j1:j2],
        'plus': after[j1:j2]
      })
  final_results = []
  # finally, create a human readable string of information.
  for v in results:
    if 'minus' in v and 'plus' in v and len(v['minus']) > 0 and len(v['plus']) > 0:
      final_results.append("-%s-+%s+"% (v['minus'],v['plus']))
    elif 'minus' in v and len(v['minus']) > 0:
      final_results.append("-%s-"% (v['minus']))
    elif 'plus' in v and len(v['plus']) > 0:
      final_results.append("+%s+"% (v['plus']))
    elif 'equal' in v:
      final_results.append("%s"% (v['equal']))
  return final_results

def _append_result(results,val):
  results.append(val)
