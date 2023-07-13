pcall(require, "luacov")

local h = require("tests.helpers")
local Object = require("nui.object")
local spy = require("luassert.spy")

local function assert_class(Class, SuperClass, name)
  h.eq(type(Class), "table")

  h.eq(Class.super, SuperClass)
  h.eq(Class.name, name)
  h.eq(tostring(Class), "class " .. name)

  h.eq(type(Class.new), "function")
  h.eq(type(Class.extend), "function")

  local is_callable = pcall(function()
    return Class()
  end)
  h.eq(is_callable, true)
end

local function assert_instance(instance, Class)
  h.eq(instance.class, Class)
  h.eq(tostring(instance), "instance of class " .. Class.name)

  h.eq(instance.name, nil)
  h.eq(instance.super, nil)
  h.eq(instance.static, nil)

  h.eq(instance.new, nil)
  h.eq(instance.extend, nil)
end

local function create_classes(...)
  local by_name = {}
  local classes = {}

  for i, def in ipairs({ ... }) do
    if type(def) == "string" then
      local class = Object(def)
      assert_class(class, nil, def)
      by_name[def] = class
      classes[i] = class
    elseif type(def) == "table" then
      local super = type(def[2]) == "table" and def[2] or (by_name[def[2]] and by_name[def[2]] or nil)
      local class = super and super:extend(def[1]) or Object(def[1])
      assert_class(class, super, def[1])
      by_name[def[1]] = class
      classes[i] = class
    else
      error("invalid argument")
    end
  end

  return unpack(classes)
end

describe("nui.object", function()
  describe("class", function()
    it("can be created", function()
      local Class = Object("Class")
      assert_class(Class, nil, "Class")
    end)

    describe("static", function()
      describe("method", function()
        describe(":new", function()
          it("is called when creating instance", function()
            local Class = Object("Class")

            spy.on(Class.static, "new")
            Class()
            assert.spy(Class.static.new).called_with(Class)
            Class.static.new:revert()

            spy.on(Class.static, "new")
            Class:new()
            assert.spy(Class.static.new).called_with(Class)
            Class.static.new:revert()
          end)

          it("creates new instance", function()
            local Class = Object("Class")

            local instance = Class:new()
            assert_instance(instance, Class)
          end)
        end)

        describe(":extend", function()
          it("creates subclass", function()
            local Class = Object("Class")

            local SubClass = Class:extend("SubClass")
            assert_class(SubClass, Class, "SubClass")
          end)
        end)

        describe(":is_subclass_of", function()
          it("works", function()
            local A, B, C = create_classes("A", { "B", "A" }, { "C", "B" })

            for _, class in ipairs({ A, B, C }) do
              h.eq(class.is_subclass_of, Object.is_subclass)
            end

            h.eq(A:is_subclass_of(A), false)
            h.eq(A:is_subclass_of(B), false)
            h.eq(A:is_subclass_of(C), false)

            h.eq(B:is_subclass_of(A), true)
            h.eq(B:is_subclass_of(B), false)
            h.eq(B:is_subclass_of(C), false)

            h.eq(C:is_subclass_of(A), true)
            h.eq(C:is_subclass_of(B), true)
            h.eq(C:is_subclass_of(C), false)
          end)
        end)
      end)

      local function define_static_say_level(A)
        A.static.level = 1
        function A.static.say_level(class)
          return "Level: " .. class.level
        end

        h.eq(A.level, 1)
        h.eq(A:say_level(), "Level: 1")
      end

      it("can be defined for class", function()
        local A = create_classes("A")
        define_static_say_level(A)
      end)

      it("is inherited by subclass", function()
        local A, B = create_classes("A", { "B", "A" })

        define_static_say_level(A)

        h.eq(B.level, 1)
        h.eq(B:say_level(), "Level: 1")

        local C, D = create_classes({ "C", A }, { "D", B })

        h.eq(C.level, 1)
        h.eq(C:say_level(), "Level: 1")

        h.eq(D.level, 1)
        h.eq(D:say_level(), "Level: 1")
      end)

      it("can be redefined for subclass", function()
        local A = create_classes("A")
        define_static_say_level(A)

        local B = create_classes({ "B", A })

        B.static.level = 2
        h.eq(B:say_level(), "Level: 2")

        function B.static.say_level(class)
          return "LEVEL: " .. class.level
        end
        h.eq(B:say_level(), "LEVEL: 2")

        local C, D = create_classes({ "C", A }, { "D", B })

        C.static.level = 2
        h.eq(C:say_level(), "Level: 2")

        D.static.level = 3
        h.eq(D:say_level(), "LEVEL: 3")
      end)

      it("for subclass does not affect super", function()
        local A = create_classes("A")
        define_static_say_level(A)

        local B = create_classes({ "B", A })

        B.static.level = 2
        function B.static.say_level(class)
          return "LEVEL: " .. class.level
        end

        h.eq(A:say_level(), "Level: 1")

        local C = create_classes({ "C", B })

        function C.static.say_name(class)
          return class.name
        end

        h.eq(C:say_name(), "C")

        h.eq(type(C.say_name), "function")
        h.eq(type(B.say_name), "nil")
        h.eq(type(A.say_name), "nil")
      end)
    end)

    describe("instance", function()
      it("can be created", function()
        local A = create_classes("A")

        local a = A:new()
        assert_instance(a, A)
      end)

      describe("method", function()
        describe(":is_instance_of", function()
          it("works", function()
            local A, B, C, D = create_classes("A", { "B", "A" }, { "C", "B" }, "D")

            local a, b, c, d = A:new(), B:new(), C:new(), D:new()

            for _, instance in ipairs({ a, b, c, d }) do
              h.eq(instance.is_instance_of, Object.is_instance)
            end

            h.eq(a:is_instance_of(A), true)
            h.eq(a:is_instance_of(B), false)
            h.eq(a:is_instance_of(C), false)
            h.eq(a:is_instance_of(D), false)

            h.eq(b:is_instance_of(A), true)
            h.eq(b:is_instance_of(B), true)
            h.eq(b:is_instance_of(C), false)
            h.eq(b:is_instance_of(D), false)

            h.eq(c:is_instance_of(A), true)
            h.eq(c:is_instance_of(B), true)
            h.eq(c:is_instance_of(C), true)
            h.eq(c:is_instance_of(D), false)

            h.eq(d:is_instance_of(A), false)
            h.eq(d:is_instance_of(B), false)
            h.eq(d:is_instance_of(C), false)
            h.eq(d:is_instance_of(D), true)
          end)
        end)

        it("can be defined", function()
          local A = create_classes("A")

          function A:before_instance_creation()
            return "before " .. self.class.name .. " instance"
          end

          local a = A:new()

          function A:after_instance_creation()
            return "after " .. self.class.name .. " instance"
          end

          h.eq(a:before_instance_creation(), "before A instance")
          h.eq(a:after_instance_creation(), "after A instance")
        end)

        it("can be inherited", function()
          local A, B = create_classes("A", { "B", "A" })

          function A:say_class_name()
            return self.class.name
          end

          local a = A:new()
          h.eq(a:say_class_name(), "A")

          local b = B:new()
          h.eq(b:say_class_name(), "B")

          local C = create_classes({ "C", B })

          local c = C:new()
          h.eq(c:say_class_name(), "C")
        end)

        it("can be redefined", function()
          local A, B = create_classes("A", { "B", "A" })

          function A:say_class_name()
            return self.class.name
          end

          local a = A:new()
          h.eq(a:say_class_name(), "A")

          function B:say_class_name()
            return string.lower(self.class.name)
          end

          local b = B:new()
          h.eq(b:say_class_name(), "b")

          local C = create_classes({ "C", B })

          local c = C:new()
          h.eq(c:say_class_name(), "c")

          function C:say_class_name()
            return string.rep(self.class.name, 3)
          end

          h.eq(c:say_class_name(), "CCC")

          C.say_class_name = nil

          h.eq(c:say_class_name(), "c")

          B.say_class_name = nil

          h.eq(c:say_class_name(), "C")
        end)
      end)

      describe("metamethod", function()
        describe("__index", function()
          it("can be set to table", function()
            local A = create_classes("A")

            function A:upper(str) -- luacheck: no unused args
              return string.upper(str)
            end

            A.__index = {
              upper = function(_, str)
                return str
              end,
              lower = function(_, str)
                return string.lower(str)
              end,
            }

            local a = A()

            h.eq(a:upper("y"), "Y")

            h.eq(a:lower("Y"), "y")

            A.__index = nil

            h.eq(type(a.lower), "nil")
          end)

          it("can be set to function", function()
            local A = create_classes("A")

            function A:upper(str) -- luacheck: no unused args
              return string.upper(str)
            end

            local index = {
              upper = function(self, str) -- luacheck: no unused args
                return str
              end,
              lower = function(self, str) -- luacheck: no unused args
                return string.lower(str)
              end,
            }

            A.__index = function(self, key) -- luacheck: no unused args
              return index[key]
            end

            local a = A()

            h.eq(a:upper("y"), "Y")

            h.eq(a:lower("Y"), "y")

            A.__index = nil

            h.eq(type(a.lower), "nil")
          end)
        end)

        describe("__tostring", function()
          it("can be redefined", function()
            local A, B = create_classes("A", { "B", "A" })

            local a = A()

            h.eq(tostring(a), "instance of class A")

            function A:__tostring()
              return "class " .. self.class.name .. "'s child"
            end

            h.eq(tostring(a), "class A's child")

            local b = B()

            h.eq(tostring(b), "class B's child")

            function B:__tostring()
              return "child of " .. self.class.name
            end

            h.eq(tostring(b), "child of B")

            B.__tostring = nil

            h.eq(tostring(b), "class B's child")
          end)
        end)
      end)
    end)
  end)
end)
