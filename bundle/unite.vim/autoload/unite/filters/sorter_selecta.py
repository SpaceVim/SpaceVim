"""===========================================================================
" FILE: sorter_selecta.py
" AUTHOR:  David Lee
" CONTRIBUTOR:  Jean Cavallo
" DESCRIPTION: Scoring code by Gary Bernhardt
"     https://github.com/garybernhardt/selecta
" License: MIT license
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"=========================================================================="""
import vim
import string
BOUNDARY_CHARS = string.punctuation + string.whitespace


def score():
    score = get_score(vim.eval('candidate.word'), vim.eval('input'))
    if score:
        vim.command('let candidate.filter__rank += %s' % score)


def get_score(string, query_chars):
    # Highest possible score is the string length
    best_score, best_range = len(string), None
    head, tail = query_chars[0], query_chars[1:]

    # For each occurence of the first character of the query in the string
    for first_index in (idx for idx, val in enumerate(string)
            if val == head):
        # Get the score for the rest
        score, last_index = find_end_of_match(string, tail, first_index)

        if last_index and score < best_score:
            best_score = score
            best_range = (first_index, last_index)

    # Solve equal scores by sorting on the string length. The ** 0.5 part makes
    # it less and less important for big strings
    best_score = best_score * (len(string) ** 0.5)
    return best_score


def find_end_of_match(to_match, chars, first_index):
    score, last_index, last_type = 1.0, first_index, None

    for char in chars:
        try:
            index = to_match.index(char, last_index + 1)
        except ValueError:
            return None, None
        if not index:
            return None, None

        # Do not count sequential characters more than once
        if index == last_index + 1:
            if last_type != 'sequential':
                last_type = 'sequential'
                score += 1
        # Same for first characters of words
        elif to_match[index - 1] in BOUNDARY_CHARS:
            if last_type != 'boundary':
                last_type = 'boundary'
                score += 1
        # Same for camel case
        elif char in string.ascii_uppercase and \
                to_match[index - 1] in string.ascii_lowercase:
            if last_type != 'camelcase':
                last_type = 'camelcase'
                score += 1
        else:
            last_type = 'normal'
            score += index - last_index
        last_index = index
    return (score, last_index)
