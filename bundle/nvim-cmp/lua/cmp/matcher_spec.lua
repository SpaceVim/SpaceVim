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
    assert.is.truthy(matcher.match('fmodify', 'fnamemodify') >= 1)
    assert.is.truthy(matcher.match('candlesingle', 'candle#accept#single') >= 1)
    assert.is.truthy(matcher.match('conso', 'console') > matcher.match('conso', 'ConstantSourceNode'))
    assert.is.truthy(matcher.match('var_', 'var_dump') >= 1)
    assert.is.truthy(matcher.match('my_', 'my_awesome_variable') > matcher.match('my_', 'completion_matching_strategy_list'))
    assert.is.truthy(matcher.match('luacon', 'lua_context') > matcher.match('luacon', 'LuaContext'))
    assert.is.truthy(matcher.match('call', 'calc') == 0)

    assert.is.truthy(matcher.match('vi', 'void#') >= 1)
    assert.is.truthy(matcher.match('vo', 'void#') >= 1)
    assert.is.truthy(matcher.match('usela', 'useLayoutEffect') > matcher.match('usela', 'useDataLayer'))
    assert.is.truthy(matcher.match('true', 'v:true', { 'true' }) == matcher.match('true', 'true'))
    assert.is.truthy(matcher.match('g', 'get', { 'get' }) > matcher.match('g', 'dein#get', { 'dein#get' }))
    assert.is.truthy(matcher.match('2', '[[2021') >= 1)
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
