local curl = require "plenary.curl"
local eq = assert.are.same
local incl = function(p, s)
  return (nil ~= string.find(s, p))
end

describe("CURL Wrapper:", function()
  describe("request", function() -----------------------------------------------
    it("sends and returns table.", function()
      eq(
        "table",
        type(curl.request {
          url = "https://postman-echo.com/get",
          method = "get",
          accept = "application/json",
        })
      )
    end)

    it("should accept the url as first argument.", function()
      local res = curl.get("https://postman-echo.com/get", {
        accept = "application/json",
      })
      eq(200, res.status)
    end)
  end)

  describe("GET", function() --------------------------------------------------
    it("sends and returns table.", function()
      eq(
        "table",
        type(curl.get {
          url = "https://postman-echo.com/get",
          accept = "application/json",
        })
      )
    end)

    it("should accept the url as first argument.", function()
      local res = curl.get("https://postman-echo.com/get", {
        accept = "application/json",
      })
      eq(200, res.status) -- table has response status
    end)

    it("sends encoded URL query params.", function()
      local query = { name = "john Doe", key = "123456" }
      local response = curl.get("https://postman-echo.com/get", {
        query = query,
      })

      eq(200, response.status)
      eq(query, vim.fn.json_decode(response.body).args)
    end)

    it("downloads files to opts.output synchronously", function()
      local file = "https://media2.giphy.com/media/bEMcuOG3hXVnihvB7x/giphy.gif"
      local loc = "/tmp/giphy2.gif"
      local res = curl.get(file, { output = loc })

      eq(1, vim.fn.filereadable(loc), "should exists")
      eq(200, res.status, "should return 200")
      eq(0, res.exit, "should have exit code of 0")
      vim.fn.delete(loc)
    end)

    it("downloads files to to opts.output asynchronous", function()
      local res = nil
      local succ = nil
      local done = false
      local file = "https://media2.giphy.com/media/notvalid.gif"
      local loc = "/tmp/notvalid.gif"

      curl.get(file, {
        output = loc,
        callback = function(out)
          done = true
          succ = out.status == 200
          res = out
        end,
      })

      vim.wait(60000, function()
        return done
      end)

      eq(403, res.status, "It should return 403")
      assert(not succ, "It should fail")

      vim.fn.delete(loc)
    end)

    it("sends with basic-auth as string", function()
      local url = "https://postman-echo.com/basic-auth"
      local auth, res

      auth = "postman:password"
      res = curl.get(url, { auth = auth })
      assert(incl("authenticated.*true", res.body))
      eq(200, res.status)

      auth = "tami5:123456"
      res = curl.get(url, { auth = auth })
      assert(not incl("authenticated.*true", res.body), "it should fail")
      eq(401, res.status)
    end)

    it("sends with basic-auth as table", function()
      local url = "https://postman-echo.com/basic-auth"
      local res = curl.get(url, { auth = { postman = "password" } })
      assert(incl("authenticated.*true", res.body))
      eq(200, res.status)
    end)
  end)

  describe("POST", function() --------------------------------------------------
    it("sends raw string", function()
      local res = curl.post("https://postman-echo.com/post", {
        body = "John Doe",
      })
      assert(incl("John", res.body))
      eq(200, res.status)
    end)

    it("sends lua table", function()
      local res = curl.post("https://jsonplaceholder.typicode.com/posts", {
        body = {
          title = "Hello World",
          body = "...",
        },
      })
      eq(201, res.status)
    end)

    it("sends file", function()
      local res = curl.post("https://postman-echo.com/post", {
        body = "./README.md",
      }).body

      assert(incl("plenary.test_harness", res))
    end)

    it("sends and recives json body.", function()
      local json = { title = "New", name = "YORK" }
      local res = curl.post("https://postman-echo.com/post", {
        body = vim.fn.json_encode(json),
        headers = {
          content_type = "application/json",
        },
      }).body
      eq(json, vim.fn.json_decode(res).json)
    end)

    it("should not include the body twice", function()
      local json = { title = "New", name = "YORK" }
      local body = vim.fn.json_encode(json)
      local res = curl.post("https://postman-echo.com/post", {
        body = body,
        headers = {
          content_type = "application/json",
        },
        dry_run = true,
      })
      local joined_response = table.concat(res, " ")
      local first_index = joined_response:find(body)

      eq(nil, joined_response:find(body, first_index + 1))
    end)
  end)
  describe("PUT", function() --------------------------------------------------
    it("sends changes and get be back the new version.", function()
      local cha = { title = "New Title" }
      local res = curl.put("https://jsonplaceholder.typicode.com/posts/8", {
        body = cha,
      })
      eq(cha.title, vim.fn.json_decode(res.body).title)
      eq(200, res.status)
    end)
  end)

  describe("PATCH", function() ------------------------------------------------
    it("sends changes and get be back the new version.", function()
      local cha = { title = "New Title" }
      local res = curl.patch("https://jsonplaceholder.typicode.com/posts/8", {
        body = cha,
      })
      eq(cha.title, vim.fn.json_decode(res.body).title)
      eq(200, res.status)
    end)
  end)

  describe("DELETE", function() ------------------------------------------------
    it("sends delete request", function()
      local res = curl.delete "https://jsonplaceholder.typicode.com/posts/8"
      eq(200, res.status)
    end)
  end)

  describe("DEPUG", function() --------------------------------------------------
    it("dry_run return the curl command to be ran.", function()
      local res = curl.delete("https://jsonplaceholder.typicode.com/posts/8", { dry_run = true })
      assert(type(res) == "table")
    end)
  end)
end)
