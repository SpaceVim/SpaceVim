local spec = require('cmp.utils.spec')

local matcher = require('cmp.matcher')

describe('matcher', function()
  before_each(spec.before)

  it('match', function()
    assert.is.truthy(matcher.match('', 'a') >= 1)
    assert.is.truthy(matcher.match('a', 'a') >= 1)
    assert.is.truthy(matcher.match('ab', 'a') == 0)
    assert.is.truthy(matcher.match('ab', 'ab') > matcher.match('ab', 'a_b'))
    assert.is.truthy(matcher.match('ab', 'a_b_c') > matcher.match('ac', 'a_b_c'))

    assert.is.truthy(matcher.match('bora', 'border-radius') >= 1)
    assert.is.truthy(matcher.match('woroff', 'word_offset') >= 1)
    assert.is.truthy(matcher.match('call', 'call') > matcher.match('call', 'condition_all'))
    assert.is.truthy(matcher.match('Buffer', 'Buffer') > matcher.match('Buffer', 'buffer'))
    assert.is.truthy(matcher.match('luacon', 'lua_context') > matcher.match('luacon', 'LuaContext'))
    assert.is.truthy(matcher.match('fmodify', 'fnamemodify') >= 1)
    assert.is.truthy(matcher.match('candlesingle', 'candle#accept#single') >= 1)

    assert.is.truthy(matcher.match('vi', 'void#') >= 1)
    assert.is.truthy(matcher.match('vo', 'void#') >= 1)
    assert.is.truthy(matcher.match('var_', 'var_dump') >= 1)
    assert.is.truthy(matcher.match('conso', 'console') > matcher.match('conso', 'ConstantSourceNode'))
    assert.is.truthy(matcher.match('usela', 'useLayoutEffect') > matcher.match('usela', 'useDataLayer'))
    assert.is.truthy(matcher.match('my_', 'my_awesome_variable') > matcher.match('my_', 'completion_matching_strategy_list'))
    assert.is.truthy(matcher.match('2', '[[2021') >= 1)

    assert.is.truthy(matcher.match(',', 'pri,') == 0)
    assert.is.truthy(matcher.match('/', '/**') >= 1)

    assert.is.truthy(matcher.match('true', 'v:true', { synonyms = { 'true' } }) == matcher.match('true', 'true'))
    assert.is.truthy(matcher.match('g', 'get', { synonyms = { 'get' } }) > matcher.match('g', 'dein#get', { 'dein#get' }))

    assert.is.truthy(matcher.match('Unit', 'net.UnixListener', { disallow_partial_fuzzy_matching = true }) == 0)
    assert.is.truthy(matcher.match('Unit', 'net.UnixListener', { disallow_partial_fuzzy_matching = false }) >= 1)

    assert.is.truthy(matcher.match('emg', 'error_msg') >= 1)
    assert.is.truthy(matcher.match('sasr', 'saved_splitright') >= 1)

    -- TODO: #1420 test-case
    -- assert.is.truthy(matcher.match('asset_', '????') >= 0)

    local score, matches
    score, matches = matcher.match('tail', 'HCDetails', {
      disallow_fuzzy_matching = false,
      disallow_partial_matching = false,
      disallow_prefix_unmatching = false,
      disallow_partial_fuzzy_matching = false,
    })
    assert.is.truthy(score >= 1)
    assert.equals(matches[1].word_match_start, 5)

    score = matcher.match('tail', 'HCDetails', {
      disallow_fuzzy_matching = false,
      disallow_partial_matching = false,
      disallow_prefix_unmatching = false,
      disallow_partial_fuzzy_matching = true,
    })
    assert.is.truthy(score == 0)
  end)

  it('disallow_fuzzy_matching', function()
    assert.is.truthy(matcher.match('fmodify', 'fnamemodify', { disallow_fuzzy_matching = true }) == 0)
    assert.is.truthy(matcher.match('fmodify', 'fnamemodify', { disallow_fuzzy_matching = false }) >= 1)
  end)

  it('disallow_fullfuzzy_matching', function()
    assert.is.truthy(matcher.match('svd', 'saved_splitright', { disallow_fullfuzzy_matching = true }) == 0)
    assert.is.truthy(matcher.match('svd', 'saved_splitright', { disallow_fullfuzzy_matching = false }) >= 1)
  end)

  it('disallow_partial_matching', function()
    assert.is.truthy(matcher.match('fb', 'foo_bar', { disallow_partial_matching = true }) == 0)
    assert.is.truthy(matcher.match('fb', 'foo_bar', { disallow_partial_matching = false }) >= 1)
    assert.is.truthy(matcher.match('fb', 'fboo_bar', { disallow_partial_matching = true }) >= 1)
    assert.is.truthy(matcher.match('fb', 'fboo_bar', { disallow_partial_matching = false }) >= 1)
  end)

  it('disallow_prefix_unmatching', function()
    assert.is.truthy(matcher.match('bar', 'foo_bar', { disallow_prefix_unmatching = true }) == 0)
    assert.is.truthy(matcher.match('bar', 'foo_bar', { disallow_prefix_unmatching = false }) >= 1)
  end)

  it('debug', function()
    matcher.debug = function(...)
      print(vim.inspect({ ... }))
    end
    -- print(vim.inspect({
    --   a = matcher.match('true', 'v:true', { 'true' }),
    --   b = matcher.match('true', 'true'),
    -- }))
  end)
end)
