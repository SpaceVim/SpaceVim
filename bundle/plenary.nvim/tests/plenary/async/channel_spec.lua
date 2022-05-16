require("plenary.async").tests.add_to_env()
local channel = a.control.channel
local eq = assert.are.same
local apcall = a.util.apcall

describe("channel", function()
  describe("oneshot", function()
    a.it("should work when rx is used first", function()
      local tx, rx = channel.oneshot()

      a.run(function()
        local got = rx()

        eq("sent value", got)
      end)

      tx "sent value"
    end)

    a.it("should work when tx is used first", function()
      local tx, rx = channel.oneshot()

      tx "sent value"

      local got = rx()

      eq("sent value", got)
    end)

    a.it("should work with multiple returns", function()
      local tx, rx = channel.oneshot()

      a.run(function()
        local got, got2 = rx()
        eq("sent value", got)
        eq("another sent value", got2)
      end)

      tx("sent value", "another sent value")
    end)

    a.it("should work when sending a falsey value", function()
      local tx, rx = channel.oneshot()

      tx(false)

      local res = rx()
      eq(res, false)

      local stat, ret = apcall(rx)
      eq(stat, false)
      local stat, ret = apcall(rx)
      eq(stat, false)
    end)

    a.it("should work when sending a nil value", function()
      local tx, rx = channel.oneshot()

      tx(nil)

      local res = rx()
      eq(res, nil)

      local stat, ret = apcall(rx)
      eq(stat, false)
      local stat, ret = apcall(rx)
      eq(stat, false)
    end)

    a.it("should error when sending mulitple times", function()
      local tx, rx = channel.oneshot()

      tx()
      local stat = pcall(tx)
      eq(stat, false)
    end)

    a.it("should block receiving multiple times", function()
      local tx, rx = channel.oneshot()
      tx(true)
      rx()
      local stat = apcall(rx)
      eq(stat, false)
    end)
  end)

  describe("counter", function()
    a.it("should work", function()
      local tx, rx = channel.counter()

      tx.send()
      tx.send()
      tx.send()

      local counter = 0

      a.run(function()
        for i = 1, 3 do
          rx.recv()
          counter = counter + 1
        end
      end)

      eq(counter, 3)
    end)

    a.it("should work when getting last", function()
      local tx, rx = channel.counter()

      tx.send()
      tx.send()
      tx.send()

      local counter = 0

      a.run(function()
        rx.last()
        counter = counter + 1
      end)

      eq(counter, 1)
    end)
  end)
end)
