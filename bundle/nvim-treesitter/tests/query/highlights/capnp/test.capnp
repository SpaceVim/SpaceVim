# Copyright (c) 2013-2014 Sandstorm Development Group, Inc. and contributors
# Licensed under the MIT License:
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

@0xd508eebdc2dc42b8;
# <- @preproc
#                  ^ @punctuation.delimiter

using Cxx = import "c++.capnp";
# <- @include
#     ^^^ @type
#         ^ @operator
#           ^^^^^^ @include
#                  ^^^^^^^^^^^ @string

# Use a namespace likely to cause trouble if the generated code doesn't use fully-qualified
# names for stuff in the capnproto namespace.
$Cxx.namespace("capnproto_test::capnp::test");

enum TestEnum {
# <- @keyword
#    ^^^^^^^^ @type
  foo @0;
# ^^^ @constant
#     ^^ @label
  bar @1;
  baz @2;
  qux @3;
  quux @4;
  corge @5;
  grault @6;
  garply @7;
}
# <- @punctuation.bracket

struct TestAllTypes {
# <- @keyword
  voidField      @0  : Void;
# ^^^^^^^^^ @field
#                    ^ @punctuation.special
#                      ^^^^ @type.builtin
  boolField      @1  : Bool;
  int8Field      @2  : Int8;
  int16Field     @3  : Int16;
  int32Field     @4  : Int32;
  int64Field     @5  : Int64;
  uInt8Field     @6  : UInt8;
  uInt16Field    @7  : UInt16;
  uInt32Field    @8  : UInt32;
  uInt64Field    @9  : UInt64;
  float32Field   @10 : Float32;
  float64Field   @11 : Float64;
  textField      @12 : Text;
  dataField      @13 : Data;
  structField    @14 : TestAllTypes;
  enumField      @15 : TestEnum;
  interfaceField @16 : Void;  # TODO

  voidList      @17 : List(Void);
  boolList      @18 : List(Bool);
  int8List      @19 : List(Int8);
  int16List     @20 : List(Int16);
  int32List     @21 : List(Int32);
  int64List     @22 : List(Int64);
  uInt8List     @23 : List(UInt8);
  uInt16List    @24 : List(UInt16);
  uInt32List    @25 : List(UInt32);
  uInt64List    @26 : List(UInt64);
  float32List   @27 : List(Float32);
  float64List   @28 : List(Float64);
  textList      @29 : List(Text);
  dataList      @30 : List(Data);
  structList    @31 : List(TestAllTypes);
  enumList      @32 : List(TestEnum);
  interfaceList @33 : List(Void);  # TODO
}

struct TestInterleavedGroups {
  group1 :group {
    foo @0 :UInt32;
    bar @2 :UInt64;
    union {
#   ^^^^^ @keyword
      qux @4 :UInt16;
      corge :group {
#     ^^^^^ @type
        grault @6 :UInt64;
        garply @8 :UInt16;
        plugh @14 :Text;
        xyzzy @16 :Text;
      }

      fred @12 :Text;
    }

    waldo @10 :Text;
  }

  group2 :group {
#         ^^^^^ @keyword
    foo @1 :UInt32;
    bar @3 :UInt64;
    union {
      qux @5 :UInt16;
      corge :group {
        grault @7 :UInt64;
        garply @9 :UInt16;
        plugh @15 :Text;
        xyzzy @17 :Text;
      }

      fred @13 :Text;
    }

    waldo @11 :Text;
  }
}

struct TestUnionDefaults {
  s16s8s64s8Set @0 :TestUnion =
      (union0 = (u0f0s16 = 321), union1 = (u1f0s8 = 123), union2 = (u2f0s64 = 12345678901234567),
#                          ^^^ @number
       union3 = (u3f0s8 = 55));
  s0sps1s32Set @1 :TestUnion =
      (union0 = (u0f1s0 = void), union1 = (u1f0sp = "foo"), union2 = (u2f0s1 = true),
#                                                   ^^^^^ @string
#                                                                              ^^^^ @boolean
       union3 = (u3f0s32 = 12345678));

  unnamed1 @2 :TestUnnamedUnion = (foo = 123);
  unnamed2 @3 :TestUnnamedUnion = (bar = 321, before = "foo", after = "bar");
}

struct TestUsing {
  using OuterNestedEnum = TestNestedTypes.NestedEnum;
# ^^^^^ @include
  using TestNestedTypes.NestedStruct.NestedEnum;

  outerNestedEnum @1 :OuterNestedEnum = bar;
  innerNestedEnum @0 :NestedEnum = quux;
}

struct TestListDefaults {
  lists @0 :TestLists = (
      list0  = [(f = void), (f = void)],
#                    ^^^^ @constant.builtin
      list1  = [(f = true), (f = false), (f = true), (f = true)],
      list8  = [(f = 123), (f = 45)],
      list16 = [(f = 12345), (f = 6789)],
      list32 = [(f = 123456789), (f = 234567890)],
      list64 = [(f = 1234567890123456), (f = 2345678901234567)],
      listP  = [(f = "foo"), (f = "bar")],
      int32ListList = [[1, 2, 3], [4, 5], [12341234]],
      textListList = [["foo", "bar"], ["baz"], ["qux", "corge"]],
      structListList = [[(int32Field = 123), (int32Field = 456)], [(int32Field = 789)]]);
}

struct TestWholeFloatDefault {
  # At one point, these failed to compile in C++ because it would produce literals like "123f",
  # which is not valid; it needs to be "123.0f".
  field @0 :Float32 = 123;
  bigField @1 :Float32 = 2e30;
  const constant :Float32 = 456;
  const bigConstant :Float32 = 4e30;
#                              ^^^^ @float
}

struct TestGenerics(Foo, Bar) {
  foo @0 :Foo;
  rev @1 :TestGenerics(Bar, Foo);

  union {
    uv @2:Void;
    ug :group {
      ugfoo @3:Int32;
    }
  }

  list @4 :List(Inner);
  # At one time this failed to compile with MSVC due to poor expression SFINAE support.

  struct Inner {
    foo @0 :Foo;
    bar @1 :Bar;
  }

  struct Inner2(Baz) {
    bar @0 :Bar;
    baz @1 :Baz;
    innerBound @2 :Inner;
    innerUnbound @3 :TestGenerics.Inner;

    struct DeepNest(Qux) {
      foo @0 :Foo;
      bar @1 :Bar;
      baz @2 :Baz;
      qux @3 :Qux;

      interface DeepNestInterface(Quux) {
#     ^^^^^^^^^ @keyword
        # At one time this failed to compile.
        call @0 () -> ();
#       ^^^^ @method
#                  ^^ @punctuation.delimiter
      }
    }
  }

  interface Interface(Qux) {
    call @0 Inner2(Text) -> (qux :Qux, gen :TestGenerics(TestAllTypes, TestAnyPointer));
#                            ^^^ @parameter
#                                      ^^^ @parameter
  }

  annotation ann(struct) :Foo;
# ^^^^^^^^^^ @keyword
#            ^^^ @method
#                ^^^^^^ @parameter.builtin

  using AliasFoo = Foo;
  using AliasInner = Inner;
  using AliasInner2 = Inner2;
  using AliasInner2Text = Inner2(Text);
  using AliasRev = TestGenerics(Bar, Foo);

  struct UseAliases {
    foo @0 :AliasFoo;
    inner @1 :AliasInner;
    inner2 @2 :AliasInner2;
    inner2Bind @3 :AliasInner2(Text);
    inner2Text @4 :AliasInner2Text;
    revFoo @5 :AliasRev.AliasFoo;
  }
}

struct BoxedText { text @0 :Text; }
using BrandedAlias = TestGenerics(BoxedText, Text);

struct TestGenericsWrapper(Foo, Bar) {
  value @0 :TestGenerics(Foo, Bar);
}

struct TestGenericsWrapper2 {
  value @0 :TestGenericsWrapper(Text, TestAllTypes);
}

interface TestImplicitMethodParams {
  call @0 [T, U] (foo :T, bar :U) -> TestGenerics(T, U);
#          ^ @type
#                      ^ @type
}

interface TestImplicitMethodParamsInGeneric(V) {
  call @0 [T, U] (foo :T, bar :U) -> TestGenerics(T, U);
}

struct TestGenericsUnion(Foo, Bar) {
  # At one point this failed to compile.

  union {
    foo @0 :Foo;
    bar @1 :Bar;
  }
}

struct TestUseGenerics $TestGenerics(Text, Data).ann("foo") {
#                      ^ @punctuation.special
#                       ^^^^^^^^^^^^ @attribute
#                                               ^ @punctuation.delimiter
#                                                ^^^ @attribute
  basic @0 :TestGenerics(TestAllTypes, TestAnyPointer);
  inner @1 :TestGenerics(TestAllTypes, TestAnyPointer).Inner;
  inner2 @2 :TestGenerics(TestAllTypes, TestAnyPointer).Inner2(Text);
  unspecified @3 :TestGenerics;
  unspecifiedInner @4 :TestGenerics.Inner2(Text);
  wrapper @8 :TestGenericsWrapper(TestAllTypes, TestAnyPointer);
  cap @18 :TestGenerics(TestInterface, Text);
  genericCap @19 :TestGenerics(TestAllTypes, List(UInt32)).Interface(Data);

  default @5 :TestGenerics(TestAllTypes, Text) =
      (foo = (int16Field = 123), rev = (foo = "text", rev = (foo = (int16Field = 321))));
  defaultInner @6 :TestGenerics(TestAllTypes, Text).Inner =
      (foo = (int16Field = 123), bar = "text");
  defaultUser @7 :TestUseGenerics = (basic = (foo = (int16Field = 123)));
  defaultWrapper @9 :TestGenericsWrapper(Text, TestAllTypes) =
      (value = (foo = "text", rev = (foo = (int16Field = 321))));
  defaultWrapper2 @10 :TestGenericsWrapper2 =
      (value = (value = (foo = "text", rev = (foo = (int16Field = 321)))));

  aliasFoo @11 :TestGenerics(TestAllTypes, TestAnyPointer).AliasFoo = (int16Field = 123);
  aliasInner @12 :TestGenerics(TestAllTypes, TestAnyPointer).AliasInner
      = (foo = (int16Field = 123));
  aliasInner2 @13 :TestGenerics(TestAllTypes, TestAnyPointer).AliasInner2
      = (innerBound = (foo = (int16Field = 123)));
  aliasInner2Bind @14 :TestGenerics(TestAllTypes, TestAnyPointer).AliasInner2(List(UInt32))
      = (baz = [12, 34], innerBound = (foo = (int16Field = 123)));
  aliasInner2Text @15 :TestGenerics(TestAllTypes, TestAnyPointer).AliasInner2Text
      = (baz = "text", innerBound = (foo = (int16Field = 123)));
  aliasRev @16 :TestGenerics(TestAnyPointer, Text).AliasRev.AliasFoo = "text";

  useAliases @17 :TestGenerics(TestAllTypes, List(UInt32)).UseAliases = (
      foo = (int16Field = 123),
      inner = (foo = (int16Field = 123)),
      inner2 = (innerBound = (foo = (int16Field = 123))),
      inner2Bind = (baz = "text", innerBound = (foo = (int16Field = 123))),
      inner2Text = (baz = "text", innerBound = (foo = (int16Field = 123))),
      revFoo = [12, 34, 56]);
}

struct TestEmptyStruct {}

struct TestConstants {
  const voidConst      :Void    = void;
# ^^^^^ @type.qualifier
  const boolConst      :Bool    = true;
  const int8Const      :Int8    = -123;
  const int16Const     :Int16   = -12345;
  const int32Const     :Int32   = -12345678;
  const int64Const     :Int64   = -123456789012345;
  const uint8Const     :UInt8   = 234;
  const uint16Const    :UInt16  = 45678;
  const uint32Const    :UInt32  = 3456789012;
  const uint64Const    :UInt64  = 12345678901234567890;
  const float32Const   :Float32 = 1234.5;
  const float64Const   :Float64 = -123e45;
  const textConst      :Text    = "foo";
  const dataConst      :Data    = "bar";
  const structConst    :TestAllTypes = (
      voidField      = void,
      boolField      = true,
      int8Field      = -12,
      int16Field     = 3456,
      int32Field     = -78901234,
      int64Field     = 56789012345678,
      uInt8Field     = 90,
      uInt16Field    = 1234,
      uInt32Field    = 56789012,
      uInt64Field    = 345678901234567890,
      float32Field   = -1.25e-10,
      float64Field   = 345,
      textField      = "baz",
      dataField      = "qux",
      structField    = (
          textField = "nested",
          structField = (textField = "really nested")),
      enumField      = baz,
      # interfaceField can't have a default

      voidList      = [void, void, void],
      boolList      = [false, true, false, true, true],
      int8List      = [12, -34, -0x80, 0x7f],
      int16List     = [1234, -5678, -0x8000, 0x7fff],
      int32List     = [12345678, -90123456, -0x80000000, 0x7fffffff],
      int64List     = [123456789012345, -678901234567890, -0x8000000000000000, 0x7fffffffffffffff],
      uInt8List     = [12, 34, 0, 0xff],
      uInt16List    = [1234, 5678, 0, 0xffff],
      uInt32List    = [12345678, 90123456, 0, 0xffffffff],
      uInt64List    = [123456789012345, 678901234567890, 0, 0xffffffffffffffff],
      float32List   = [0, 1234567, 1e37, -1e37, 1e-37, -1e-37],
      float64List   = [0, 123456789012345, 1e306, -1e306, 1e-306, -1e-306],
      textList      = ["quux", "corge", "grault"],
      dataList      = ["garply", "waldo", "fred"],
      structList    = [
          (textField = "x " "structlist"
                       " 1"),
          (textField = "x structlist 2"),
          (textField = "x structlist 3")],
      enumList      = [qux, bar, grault]
      # interfaceList can't have a default
      );
  const enumConst      :TestEnum = corge;

  const voidListConst      :List(Void)    = [void, void, void, void, void, void];
  const boolListConst      :List(Bool)    = [true, false, false, true];
  const int8ListConst      :List(Int8)    = [111, -111];
  const int16ListConst     :List(Int16)   = [11111, -11111];
  const int32ListConst     :List(Int32)   = [111111111, -111111111];
  const int64ListConst     :List(Int64)   = [1111111111111111111, -1111111111111111111];
  const uint8ListConst     :List(UInt8)   = [111, 222] ;
  const uint16ListConst    :List(UInt16)  = [33333, 44444];
  const uint32ListConst    :List(UInt32)  = [3333333333];
  const uint64ListConst    :List(UInt64)  = [11111111111111111111];
  const float32ListConst   :List(Float32) = [5555.5, inf, -inf, nan];
  const float64ListConst   :List(Float64) = [7777.75, inf, -inf, nan];
  const textListConst      :List(Text)    = ["plugh", "xyzzy", "thud"];
  const dataListConst      :List(Data)    = ["oops", "exhausted", "rfc3092"];
  const structListConst    :List(TestAllTypes) = [
      (textField = "structlist 1"),
      (textField = "structlist 2"),
      (textField = "structlist 3")];
  const enumListConst      :List(TestEnum) = [foo, garply];
}

const globalInt :UInt32 = 12345;
const globalText :Text = "foobar";
const globalStruct :TestAllTypes = (int32Field = 54321);
const globalPrintableStruct :TestPrintInlineStructs = (someText = "foo");
const derivedConstant :TestAllTypes = (
    uInt32Field = .globalInt,
    textField = TestConstants.textConst,
    structField = TestConstants.structConst,
    int16List = TestConstants.int16ListConst,
    structList = TestConstants.structListConst);

const genericConstant :TestGenerics(TestAllTypes, Text) =
    (foo = (int16Field = 123), rev = (foo = "text", rev = (foo = (int16Field = 321))));

const embeddedData :Data = embed "testdata/packed";
#                          ^^^^^ @include
const embeddedText :Text = embed "testdata/short.txt";
const embeddedStruct :TestAllTypes = embed "testdata/binary";

const nonAsciiText :Text = "♫ é ✓";

const blockText :Text =
    `foo bar baz
    `"qux" `corge` 'grault'
    "regular\"quoted\"line"
    `garply\nwaldo\tfred\"plugh\"xyzzy\'thud
    ;

struct TestAnyPointerConstants {
  anyKindAsStruct @0 :AnyPointer;
  anyStructAsStruct @1 :AnyStruct;
  anyKindAsList @2 :AnyPointer;
  anyListAsList @3 :AnyList;
}

const anyPointerConstants :TestAnyPointerConstants = (
  anyKindAsStruct = TestConstants.structConst,
  anyStructAsStruct = TestConstants.structConst,
  anyKindAsList = TestConstants.int32ListConst,
  anyListAsList = TestConstants.int32ListConst,
);

interface TestInterface {
  foo @0 (i :UInt32, j :Bool) -> (x :Text);
#                                 ^ @parameter
  bar @1 () -> ();
  baz @2 (s: TestAllTypes);
}

interface TestExtends extends(TestInterface) {
#                     ^^^^^^^ @keyword
  qux @0 ();
  corge @1 TestAllTypes -> ();
  grault @2 () -> TestAllTypes;
}

interface TestTailCallee $Cxx.allowCancellation {
  struct TailResult {
    i @0 :UInt32;
    t @1 :Text;
    c @2 :TestCallOrder;
  }

  foo @0 (i :Int32, t :Text) -> TailResult;
}

interface TestTailCaller {
  foo @0 (i :Int32, callee :TestTailCallee) -> TestTailCallee.TailResult;
}

interface TestStreaming $Cxx.allowCancellation {
  doStreamI @0 (i :UInt32) -> stream;
  doStreamJ @1 (j :UInt32) -> stream;
  finishStream @2 () -> (totalI :UInt32, totalJ :UInt32);
  # Test streaming. finishStream() returns the totals of the values streamed to the other calls.
}

interface TestHandle {}

interface TestMoreStuff extends(TestCallOrder) {
  # Catch-all type that contains lots of testing methods.

  callFoo @0 (cap :TestInterface) -> (s: Text);
  # Call `cap.foo()`, check the result, and return "bar".

  callFooWhenResolved @1 (cap :TestInterface) -> (s: Text);
  # Like callFoo but waits for `cap` to resolve first.

  neverReturn @2 (cap :TestInterface) -> (capCopy :TestInterface) $Cxx.allowCancellation;
  # Doesn't return.  You should cancel it.

  hold @3 (cap :TestInterface) -> ();
  # Returns immediately but holds on to the capability.

  callHeld @4 () -> (s: Text);
  # Calls the capability previously held using `hold` (and keeps holding it).

  getHeld @5 () -> (cap :TestInterface);
  # Returns the capability previously held using `hold` (and keeps holding it).

  echo @6 (cap :TestCallOrder) -> (cap :TestCallOrder);
  # Just returns the input cap.

  expectCancel @7 (cap :TestInterface) -> () $Cxx.allowCancellation;
  # evalLater()-loops forever, holding `cap`.  Must be canceled.

  methodWithDefaults @8 (a :Text, b :UInt32 = 123, c :Text = "foo") -> (d :Text, e :Text = "bar");

  methodWithNullDefault @12 (a :Text, b :TestInterface = null);

  getHandle @9 () -> (handle :TestHandle);
  # Get a new handle. Tests have an out-of-band way to check the current number of live handles, so
  # this can be used to test garbage collection.

  getNull @10 () -> (nullCap :TestMoreStuff);
  # Always returns a null capability.

  getEnormousString @11 () -> (str :Text);
  # Attempts to return an 100MB string. Should always fail.

  writeToFd @13 (fdCap1 :TestInterface, fdCap2 :TestInterface)
             -> (fdCap3 :TestInterface, secondFdPresent :Bool);
  # Expects fdCap1 and fdCap2 wrap socket file descriptors. Writes "foo" to the first and "bar" to
  # the second. Also creates a socketpair, writes "baz" to one end, and returns the other end.

  throwException @14 ();
  throwRemoteException @15 ();
}

interface TestMembrane {
  makeThing @0 () -> (thing :Thing);
  callPassThrough @1 (thing :Thing, tailCall :Bool) -> Result;
  callIntercept @2 (thing :Thing, tailCall :Bool) -> Result;
  loopback @3 (thing :Thing) -> (thing :Thing);

  waitForever @4 () $Cxx.allowCancellation;

  interface Thing {
    passThrough @0 () -> Result;
    intercept @1 () -> Result;
  }

  struct Result {
    text @0 :Text;
  }
}

struct TestNameAnnotation $Cxx.name("RenamedStruct") {
  union {
    badFieldName @0 :Bool $Cxx.name("goodFieldName");
    bar @1 :Int8;
  }

  enum BadlyNamedEnum $Cxx.name("RenamedEnum") {
    foo @0;
    bar @1;
    baz @2 $Cxx.name("qux");
  }

  anotherBadFieldName @2 :BadlyNamedEnum $Cxx.name("anotherGoodFieldName");

  struct NestedStruct $Cxx.name("RenamedNestedStruct") {
    badNestedFieldName @0 :Bool $Cxx.name("goodNestedFieldName");
    anotherBadNestedFieldName @1 :NestedStruct $Cxx.name("anotherGoodNestedFieldName");

    enum DeeplyNestedEnum $Cxx.name("RenamedDeeplyNestedEnum") {
      quux @0;
      corge @1;
      grault @2 $Cxx.name("garply");
    }
  }

  badlyNamedUnion :union $Cxx.name("renamedUnion") {
    badlyNamedGroup :group $Cxx.name("renamedGroup") {
      foo @3 :Void;
      bar @4 :Void;
    }
    baz @5 :NestedStruct $Cxx.name("qux");
  }
}

interface TestNameAnnotationInterface $Cxx.name("RenamedInterface") {
  badlyNamedMethod @0 (badlyNamedParam :UInt8 $Cxx.name("renamedParam")) $Cxx.name("renamedMethod");
}

struct TestImpliedFirstField {
  struct TextStruct {
    text @0 :Text;
    i @1 :UInt32 = 321;
  }

  textStruct @0 :TextStruct = "foo";
  textStructList @1 :List(TextStruct);

  intGroup :group {
    i @2 :UInt32;
    str @3 :Text = "corge";
  }
}

const testImpliedFirstField :TestImpliedFirstField = (
  textStruct = "bar",
  textStructList = ["baz", (text = "qux", i = 123)],
  intGroup = 123
);

struct TestCycleANoCaps {
  foo @0 :TestCycleBNoCaps;
}

struct TestCycleBNoCaps {
  foo @0 :List(TestCycleANoCaps);
  bar @1 :TestAllTypes;
}

struct TestCycleAWithCaps {
  foo @0 :TestCycleBWithCaps;
}

struct TestCycleBWithCaps {
  foo @0 :List(TestCycleAWithCaps);
  bar @1 :TestInterface;
}
