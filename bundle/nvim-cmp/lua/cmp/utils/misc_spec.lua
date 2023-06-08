local spec = require('cmp.utils.spec')

local misc = require('cmp.utils.misc')

describe('misc', function()
  before_each(spec.before)

  it('merge', function()
    local merged
    merged = misc.merge({
      a = {},
    }, {
      a = {
        b = 1,
      },
    })
    assert.are.equal(merged.a.b, 1)

    merged = misc.merge({
      a = {
        i = 1,
      },
    }, {
      a = {
        c = 2,
      },
    })
    assert.are.equal(merged.a.i, 1)
    assert.are.equal(merged.a.c, 2)

    merged = misc.merge({
      a = false,
    }, {
      a = {
        b = 1,
      },
    })
    assert.are.equal(merged.a, false)

    merged = misc.merge({
      a = misc.none,
    }, {
      a = {
        b = 1,
      },
    })
    assert.are.equal(merged.a, nil)

    merged = misc.merge({
      a = misc.none,
    }, {
      a = nil,
    })
    assert.are.equal(merged.a, nil)

    merged = misc.merge({
      a = nil,
    }, {
      a = misc.none,
    })
    assert.are.equal(merged.a, nil)
  end)
end)
