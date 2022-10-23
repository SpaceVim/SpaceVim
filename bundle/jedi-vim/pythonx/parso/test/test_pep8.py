import parso


def issues(code):
    grammar = parso.load_grammar()
    module = parso.parse(code)
    return grammar._get_normalizer_issues(module)


def test_eof_newline():
    def assert_issue(code):
        found = issues(code)
        assert len(found) == 1
        issue, = found
        assert issue.code == 292

    assert not issues('asdf = 1\n')
    assert not issues('asdf = 1\r\n')
    assert not issues('asdf = 1\r')
    assert_issue('asdf = 1')
    assert_issue('asdf = 1\n# foo')
    assert_issue('# foobar')
    assert_issue('')
    assert_issue('foo = 1  # comment')


def test_eof_blankline():
    def assert_issue(code):
        found = issues(code)
        assert len(found) == 1
        issue, = found
        assert issue.code == 391

    assert_issue('asdf = 1\n\n')
    assert_issue('# foobar\n\n')
    assert_issue('\n\n')


def test_shebang():
    assert not issues('#!\n')
    assert not issues('#!/foo\n')
    assert not issues('#! python\n')
