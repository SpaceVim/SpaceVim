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

using Cxx = import "c++.capnp";

# Use a namespace likely to cause trouble if the generated code doesn't use fully-qualified
# names for stuff in the capnproto namespace.
$Cxx.namespace("capnproto_test::capnp::test");

enum TestEnum {
  foo @0;
  bar @1;
  baz @2;
  qux @3;
  quux @4;
  corge @5;
  grault @6;
  garply @7;
}

struct TestAllTypes {
  voidField      @0  : Void;
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

struct TestDefaults {
  voidField      @0  : Void    = void;
  boolField      @1  : Bool    = true;
  int8Field      @2  : Int8    = -123;
  int16Field     @3  : Int16   = -12345;
  int32Field     @4  : Int32   = -12345678;
  int64Field     @5  : Int64   = -123456789012345;
  uInt8Field     @6  : UInt8   = 234;
  uInt16Field    @7  : UInt16  = 45678;
  uInt32Field    @8  : UInt32  = 3456789012;
  uInt64Field    @9  : UInt64  = 12345678901234567890;
  float32Field   @10 : Float32 = 1234.5;
  float64Field   @11 : Float64 = -123e45;
  textField      @12 : Text    = "foo";
  dataField      @13 : Data    = 0x"62 61 72"; # "bar"
  structField    @14 : TestAllTypes = (
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
    int64List     = [
      123456789012345, -678901234567890, 
      -0x8000000000000000, 0x7fffffffffffffff],
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
  enumField      @15 : TestEnum = corge;
  interfaceField @16 : Void;  # TODO

  voidList      @17 : List(Void)    = [void, void, void, void, void, void];
  boolList      @18 : List(Bool)    = [true, false, false, true];
  int8List      @19 : List(Int8)    = [111, -111];
  int16List     @20 : List(Int16)   = [11111, -11111];
  int32List     @21 : List(Int32)   = [111111111, -111111111];
  int64List     @22 : List(Int64)   = [1111111111111111111, -1111111111111111111];
  uInt8List     @23 : List(UInt8)   = [111, 222] ;
  uInt16List    @24 : List(UInt16)  = [33333, 44444];
  uInt32List    @25 : List(UInt32)  = [3333333333];
  uInt64List    @26 : List(UInt64)  = [11111111111111111111];
  float32List   @27 : List(Float32) = [5555.5, inf, -inf, nan];
  float64List   @28 : List(Float64) = [7777.75, inf, -inf, nan];
  textList      @29 : List(Text)    = ["plugh", "xyzzy", "thud"];
  dataList      @30 : List(Data)    = ["oops", "exhausted", "rfc3092"];
  structList    @31 : List(TestAllTypes) = [
    (textField = "structlist 1"),
    (textField = "structlist 2"),
    (textField = "structlist 3")];
  enumList      @32 : List(TestEnum) = [foo, garply];
  interfaceList @33 : List(Void);  # TODO
}

struct TestAnyPointer {
  anyPointerField @0 :AnyPointer;

  # Do not add any other fields here!  
  # Some tests rely on anyPointerField being the last pointer
  # in the struct.
}

struct TestAnyOthers {
  anyStructField @0 :AnyStruct;
  anyListField @1 :AnyList;
  capabilityField @2 :Capability;
}

struct TestOutOfOrder {
  foo @3 :Text;
  bar @2 :Text;
  baz @8 :Text;
  qux @0 :Text;
  quux @6 :Text;
  corge @4 :Text;
  grault @1 :Text;
  garply @7 :Text;
  waldo @5 :Text;
}

struct TestUnion {
  union0 @0! :union {
    # Pack union 0 under ideal conditions: there is no unused padding space prior to it.
    u0f0s0  @4: Void;
    u0f0s1  @5: Bool;
    u0f0s8  @6: Int8;
    u0f0s16 @7: Int16;
    u0f0s32 @8: Int32;
    u0f0s64 @9: Int64;
    u0f0sp  @10: Text;

    # Pack more stuff into union0 -- should go in same space.
    u0f1s0  @11: Void;
    u0f1s1  @12: Bool;
    u0f1s8  @13: Int8;
    u0f1s16 @14: Int16;
    u0f1s32 @15: Int32;
    u0f1s64 @16: Int64;
    u0f1sp  @17: Text;
  }

  # Pack one bit in order to make pathological situation for union1.
  bit0 @18: Bool;

  union1 @1! :union {
    # Pack pathologically bad case.  Each field takes up new space.
    u1f0s0  @19: Void;
    u1f0s1  @20: Bool;
    u1f1s1  @21: Bool;
    u1f0s8  @22: Int8;
    u1f1s8  @23: Int8;
    u1f0s16 @24: Int16;
    u1f1s16 @25: Int16;
    u1f0s32 @26: Int32;
    u1f1s32 @27: Int32;
    u1f0s64 @28: Int64;
    u1f1s64 @29: Int64;
    u1f0sp  @30: Text;
    u1f1sp  @31: Text;

    # Pack more stuff into union1
    # each should go into the same space as corresponding u1f0s*.
    u1f2s0  @32: Void;
    u1f2s1  @33: Bool;
    u1f2s8  @34: Int8;
    u1f2s16 @35: Int16;
    u1f2s32 @36: Int32;
    u1f2s64 @37: Int64;
    u1f2sp  @38: Text;
  }

  # Fill in the rest of that bitfield from earlier.
  bit2 @39: Bool;
  bit3 @40: Bool;
  bit4 @41: Bool;
  bit5 @42: Bool;
  bit6 @43: Bool;
  bit7 @44: Bool;

  # Interleave two unions to be really annoying.
  # Also declare in reverse order to make sure 
  # union discriminant values are sorted by field number and not by declaration order.
  union2 @2! :union {
    u2f0s64 @54: Int64;
    u2f0s32 @52: Int32;
    u2f0s16 @50: Int16;
    u2f0s8 @47: Int8;
    u2f0s1 @45: Bool;
  }

  union3 @3! :union {
    u3f0s64 @55: Int64;
    u3f0s32 @53: Int32;
    u3f0s16 @51: Int16;
    u3f0s8 @48: Int8;
    u3f0s1 @46: Bool;
  }

  byte0 @49: UInt8;
}

struct TestUnnamedUnion {
  before @0 :Text;

  union {
    foo @1 :UInt16;
    bar @3 :UInt32;
  }

  middle @2 :UInt16;

  after @4 :Text;
}

struct TestUnionInUnion {
  # There is no reason to ever do this.
  outer :union {
    inner :union {
      foo @0 :Int32;
      bar @1 :Int32;
    }
    baz @2 :Int32;
  }
}

struct TestGroups {
  groups :union {
    foo :group {
      corge @0 :Int32;
      grault @2 :Int64;
      garply @8 :Text;
    }
    bar :group {
      corge @3 :Int32;
      grault @4 :Text;
      garply @5 :Int64;
    }
    baz :group {
      corge @1 :Int32;
      grault @6 :Text;
      garply @7 :Text;
    }
  }
}

struct TestInterleavedGroups {
  group1 :group {
    foo @0 :UInt32;
    bar @2 :UInt64;
    union {
      qux @4 :UInt16;
      corge :group {
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
     union3 = (u3f0s8 = 55));
  s0sps1s32Set @1 :TestUnion =
    (union0 = (u0f1s0 = void), union1 = (u1f0sp = "foo"), union2 = (u2f0s1 = true),
     union3 = (u3f0s32 = 12345678));

  unnamed1 @2 :TestUnnamedUnion = (foo = 123);
  unnamed2 @3 :TestUnnamedUnion = (bar = 321, before = "foo", after = "bar");
}

struct TestNestedTypes {
  enum NestedEnum {
    foo @0;
    bar @1;
  }

  struct NestedStruct {
    enum NestedEnum {
      baz @0;
      qux @1;
      quux @2;
    }

    outerNestedEnum @0 :TestNestedTypes.NestedEnum = bar;
    innerNestedEnum @1 :NestedEnum = quux;
  }

  nestedStruct @0 :NestedStruct;

  outerNestedEnum @1 :NestedEnum = bar;
  innerNestedEnum @2 :NestedStruct.NestedEnum = quux;
}

struct TestUsing {
  using OuterNestedEnum = TestNestedTypes.NestedEnum;
  using TestNestedTypes.NestedStruct.NestedEnum;

  outerNestedEnum @1 :OuterNestedEnum = bar;
  innerNestedEnum @0 :NestedEnum = quux;
}

struct TestLists {
  # Small structs, when encoded as list, will be encoded as primitive lists rather than struct
  # lists, to save space.
  struct Struct0  { f @0 :Void; }
  struct Struct1  { f @0 :Bool; }
  struct Struct8  { f @0 :UInt8; }
  struct Struct16 { f @0 :UInt16; }
  struct Struct32 { f @0 :UInt32; }
  struct Struct64 { f @0 :UInt64; }
  struct StructP  { f @0 :Text; }

  # Versions of the above which cannot be encoded as primitive lists.
  struct Struct0c  { f @0 :Void; pad @1 :Text; }
  struct Struct1c  { f @0 :Bool; pad @1 :Text; }
  struct Struct8c  { f @0 :UInt8; pad @1 :Text; }
  struct Struct16c { f @0 :UInt16; pad @1 :Text; }
  struct Struct32c { f @0 :UInt32; pad @1 :Text; }
  struct Struct64c { f @0 :UInt64; pad @1 :Text; }
  struct StructPc  { f @0 :Text; pad @1 :UInt64; }

  list0  @0 :List(Struct0);
  list1  @1 :List(Struct1);
  list8  @2 :List(Struct8);
  list16 @3 :List(Struct16);
  list32 @4 :List(Struct32);
  list64 @5 :List(Struct64);
  listP  @6 :List(StructP);

  int32ListList @7 :List(List(Int32));
  textListList @8 :List(List(Text));
  structListList @9 :List(List(TestAllTypes));
}

struct TestFieldZeroIsBit {
  bit @0 :Bool;
  secondBit @1 :Bool = true;
  thirdField @2 :UInt8 = 123;
}

struct TestListDefaults {
  lists @0 :TestLists = (
    list0  = [(f = void), (f = void)],
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

struct TestLateUnion {
  # Test what happens if the unions are not the first ordinals in the struct.  
  # At one point this was broken for the dynamic API.

  foo @0 :Int32;
  bar @1 :Text;
  baz @2 :Int16;

  theUnion @3! :union {
    qux @4 :Text;
    corge @5 :List(Int32);
    grault @6 :Float32;
  }

  anotherUnion @7! :union {
    qux @8 :Text;
    corge @9 :List(Int32);
    grault @10 :Float32;
  }
}

struct TestOldVersion {
  # A subset of TestNewVersion.
  old1 @0 :Int64;
  old2 @1 :Text;
  old3 @2 :TestOldVersion;
}

struct TestNewVersion {
  # A superset of TestOldVersion.
  old1 @0 :Int64;
  old2 @1 :Text;
  old3 @2 :TestNewVersion;
  new1 @3 :Int64 = 987;
  new2 @4 :Text = "baz";
}

struct TestOldUnionVersion {
  union {
    a @0 :Void;
    b @1 :UInt64;
  }
}

struct TestNewUnionVersion {
  union {
    a :union {
      a0 @0 :Void;
      a1 @2 :UInt64;
    }
    b @1 :UInt64;
  }
}

struct TestStructUnion {
  un @0! :union {
    struct @1 :SomeStruct;
    object @2 :TestAnyPointer;
  }

  struct SomeStruct {
    someText @0 :Text;
    moreText @1 :Text;
  }
}

struct TestPrintInlineStructs {
  someText @0 :Text;

  structList @1 :List(InlineStruct);
  struct InlineStruct {
    int32Field @0 :Int32;
    textField @1 :Text;
  }
}

struct TestWholeFloatDefault {
  # At one point, these failed to compile in C++ because it would produce literals like "123f",
  # which is not valid; it needs to be "123.0f".
  field @0 :Float32 = 123;
  bigField @1 :Float32 = 2e30;
  const constant :Float32 = 456;
  const bigConstant :Float32 = 4e30;
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
        # At one time this failed to compile.
        call @0 () -> ();
      }
    }
  }

  interface Interface(Qux) {
    call @0 Inner2(Text) -> (qux :Qux, gen :TestGenerics(TestAllTypes, TestAnyPointer));
  }

  annotation ann(struct) :Foo;

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
    int64List     = [
      123456789012345, 
      -678901234567890, 
      -0x8000000000000000, 
      0x7fffffffffffffff],
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

struct TestListOfAny {
  capList @0 :List(Capability);
  #listList @1 :List(AnyList); 
  # TODO(0.10): Make List(AnyList) work correctly in C++ generated code.
}

interface TestInterface {
  foo @0 (i :UInt32, j :Bool) -> (x :Text);
  bar @1 () -> ();
  baz @2 (s: TestAllTypes);
}

interface TestExtends extends(TestInterface) {
  qux @0 ();
  corge @1 TestAllTypes -> ();
  grault @2 () -> TestAllTypes;
}

interface TestExtends2 extends(TestExtends) {}

interface TestPipeline {
  getCap @0 (n: UInt32, inCap :TestInterface) -> (s: Text, outBox :Box);
  testPointers @1 (cap :TestInterface, obj :AnyPointer, list :List(TestInterface)) -> ();
  getAnyCap @2 (n: UInt32, inCap :Capability) -> (s: Text, outBox :AnyBox);

  getCapPipelineOnly @3 () -> (outBox :Box);
  # Never returns, but uses setPipeline() to make the pipeline work.

  struct Box {
    cap @0 :TestInterface;
  }
  struct AnyBox {
    cap @0 :Capability;
  }
}

interface TestCallOrder {
  getCallSequence @0 (expected: UInt32) -> (n: UInt32);
  # First call returns 0, next returns 1, ...
  #
  # The input `expected` is ignored but useful for disambiguating debug logs.
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
  # Test streaming. finishStream() returns 
  # the totals of the values streamed to the other calls.
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

  methodWithDefaults @8 (
    a :Text, 
    b :UInt32 = 123, 
    c :Text = "foo"
  ) -> (d :Text, e :Text = "bar");

  methodWithNullDefault @12 (a :Text, b :TestInterface = null);

  getHandle @9 () -> (handle :TestHandle);
  # Get a new handle. Tests have an out-of-band way to check
  # the current number of live handles, so this can be used to test garbage collection.

  getNull @10 () -> (nullCap :TestMoreStuff);
  # Always returns a null capability.

  getEnormousString @11 () -> (str :Text);
  # Attempts to return an 100MB string. Should always fail.

  writeToFd @13 (fdCap1 :TestInterface, fdCap2 :TestInterface)
             -> (fdCap3 :TestInterface, secondFdPresent :Bool);
  # Expects fdCap1 and fdCap2 wrap socket file descriptors.
  # Writes "foo" to the first and "bar" to the second. 
  # Also creates a socketpair, writes "baz" to one end, and returns the other end.

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

struct TestContainMembrane {
  cap @0 :TestMembrane.Thing;
  list @1 :List(TestMembrane.Thing);
}

struct TestTransferCap {
  list @0 :List(Element);
  struct Element {
    text @0 :Text;
    cap @1 :TestInterface;
  }
}

interface TestKeywordMethods {
  delete @0 ();
  class @1 ();
  void @2 ();
  return @3 ();
}

interface TestAuthenticatedBootstrap(VatId) {
  getCallerId @0 () -> (caller :VatId);
}

struct TestSturdyRef {
  hostId @0 :TestSturdyRefHostId;
  objectId @1 :AnyPointer;
}

struct TestSturdyRefHostId {
  host @0 :Text;
}

struct TestSturdyRefObjectId {
  tag @0 :Tag;
  enum Tag {
    testInterface @0;
    testExtends @1;
    testPipeline @2;
    testTailCallee @3;
    testTailCaller @4;
    testMoreStuff @5;
  }
}

struct TestProvisionId {}
struct TestRecipientId {}
struct TestThirdPartyCapId {}
struct TestJoinResult {}

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
  badlyNamedMethod @0 (
    badlyNamedParam :UInt8 $Cxx.name("renamedParam")
  ) $Cxx.name("renamedMethod");
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
