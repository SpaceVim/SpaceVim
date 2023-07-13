.class public Lbaksmali/test/class;
# <- @keyword
#      ^^^^^^ @type.qualifier
.super Ljava/lang/Object;
#      ^ @character.special
#       ^^^^ @type.builtin
#           ^ @punctuation.delimiter

.source "baksmali_test_class.smali"
# <- @include

.implements Lsome/interface;
.implements Lsome/other/interface;


.annotation build Lsome/annotation;
#           ^^^^^ @storageclass
#                  ^^^^ @type
#                                 ^ @punctuation.delimiter
    value1 = "test"
#   ^^^^^^ @field
#          ^ @operator
#            ^^^^^^ @string
    value2 = .subannotation Lsome/annotation;
        value1 = "test2"
        value2 = Lsome/enum;
    .end subannotation
.end annotation

.annotation system Lsome/annotation;
.end annotation



.field public static aStaticFieldWithoutAnInitializer:I
#                                                    ^ @punctuation.delimiter
#                                                     ^ @type.builtin

.field public static longStaticField:J = 0x300000000L
#                                        ^^^^^^^^^^^^ @number
.field public static longNegStaticField:J = -0x300000000L

.field public static intStaticField:I = 0x70000000
.field public static intNegStaticField:I = -500

.field public static shortStaticField:S = 500s
.field public static shortNegStaticField:S = -500s

.field public static byteStaticField:B = 123t
.field public static byteNegStaticField:B = 0xAAt

.field public static floatStaticField:F = 3.1415926f
#                                         ^^^^^^^^^^ @float

.field public static doubleStaticField:D = 3.141592653589793

.field public static charStaticField:C = 'a'
#                                        ^^^ @character
.field public static charEscapedStaticField:C = '\n'
#                                                ^^ @string.escape

.field public static boolTrueStaticField:Z = true
#                                            ^^^^ @boolean
.field public static boolFalseStaticField:Z = false

.field public static typeStaticField:Ljava/lang/Class; = Lbaksmali/test/class;

.field public static stringStaticField:Ljava/lang/String; = "test"
.field public static stringEscapedStaticField:Ljava/lang/String; = "test\ntest"


.field public static fieldStaticField:Ljava/lang/reflect/Field; = Lbaksmali/test/class;->fieldStaticField:Ljava/lang/reflect/Field;

.field public static methodStaticField:Ljava/lang/reflect/Method; = Lbaksmali/test/class;->testMethod(ILjava/lang/String;)Ljava/lang/String;
#                                                                                        ^^ @punctuation.delimiter
#                                                                                          ^^^^^^^^^^ @method.call

.field public static arrayStaticField:[I = {1, 2, 3, {1, 2, 3, 4}}
#                                     ^ @punctuation.special
#                                          ^ @punctuation.bracket
#                                            ^ @punctuation.delimiter

.field public static enumStaticField:Lsome/enum; = .enum Lsome/enum;->someEnumValue:Lsome/enum;
#                                                                     ^^^^^^^^^^^^^ @field

.field public static annotationStaticField:Lsome/annotation; = .subannotation Lsome/annotation;
    value1 = "test"
    value2 = .subannotation Lsome/annotation;
        value1 = "test2"
        value2 = Lsome/enum;
    .end subannotation
.end subannotation

.field public static staticFieldWithAnnotation:I
    .annotation runtime La/field/annotation;
#               ^^^^^^^ @storageclass
        this = "is"
        a = "test"
    .end annotation
    .annotation runtime Lorg/junit/Test;
    .end annotation
.end field

.field public instanceField:Ljava/lang/String;



.method public constructor <init>()V
# <- @keyword.function
#              ^^^^^^^^^^^ @constructor
#                          ^^^^^^ @constructor
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
#   ^^^^^^^^^^^^^ @keyword.operator
#                  ^^ @parameter.builtin
    return-void
#   ^^^^^^^^^^^ @keyword.return
.end method

.method public testMethod(ILjava/lang/String;)Ljava/lang/String;
#              ^^^^^^^^^^ @method
    .registers 3
    .annotation runtime Lorg/junit/Test;
    .end annotation
    .annotation system Lyet/another/annotation;
        somevalue = 1234
        anothervalue = 3.14159
    .end annotation

    const-string v0, "testing\n123"
#                ^^ @variable.builtin

    goto switch:
#        ^^^^^^^ @label

    sget v0, Lbaksmali/test/class;->staticField:I

    switch:
    packed-switch v0, pswitch:

    try_start:
    const/4 v0, 7
    const v0, 10
    nop
    try_end:
    .catch Ljava/lang/Exception; {try_start: .. try_end:} handler:
#   ^^^^^^ @exception
    .catchall {try_start: .. try_end:} handler2:
#   ^^^^^^^^^ @exception
#                         ^^ @operator

    handler:

    Label10:
    Label11:
    Label12:
    Label13:
    return-object v0



    .array-data 4
        1 2 3 4 5 6 200
    .end array-data

    pswitch:
    .packed-switch 10
        Label10:
        Label11:
        Label12:
        Label13:
    .end packed-switch

    handler2:

    return-void

.end method

.method public abstract testMethod2()V
    .annotation runtime Lsome/annotation;
        subannotation = .subannotation Lsome/other/annotation;
            value = "value"
        .end subannotation
    .end annotation
    .annotation runtime Lorg/junit/Test;
    .end annotation
.end method


.method public tryTest()V
    .registers 1

    handler:
    nop


    try_start:
    const/4 v0, 7
    const v0, 10
    nop
    try_end:
    .catch Ljava/lang/Exception; {try_start: .. try_end:} handler:
.end method


.method public debugTest(IIIII)V
    .registers 10

    .parameter "Blah"
    .parameter
    .parameter "BlahWithAnnotations"
        .annotation runtime Lsome/annotation;
            something = "some value"
            somethingelse = 1234
        .end annotation
        .annotation runtime La/second/annotation;
        .end annotation
    .end parameter
    .parameter
        .annotation runtime Lsome/annotation;
            something = "some value"
            somethingelse = 1234
        .end annotation
    .end parameter
    .parameter "LastParam"

    .prologue
#   ^^^^^^^^^ @keyword

    nop
    nop

    .source "somefile.java"
#   ^^^^^^^ @include
    .line 101
#         ^^^ @text.literal

    nop


    .line 50

    .local v0, aNumber:I
#              ^^^^^^^ @variable
    const v0, 1234
    .end local v0

    .source "someotherfile.java"
    .line 900

    const-string v0, "1234"

    .restart local v0
    const v0, 6789
    .end local v0

    .epilogue
#   ^^^^^^^^^ @keyword

.end method
