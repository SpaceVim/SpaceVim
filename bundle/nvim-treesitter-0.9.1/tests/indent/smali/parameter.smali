.class public Lbaksmali/test/class;
.super Ljava/lang/Object;

.source "baksmali_test_class.smali"

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

	nop
	nop

	.source "somefile.java"
	.line 101

	nop


	.line 50

	.local v0, aNumber:I
	const v0, 1234
	.end local v0

	.source "someotherfile.java"
	.line 900

	const-string v0, "1234"

	.restart local v0
	const v0, 6789
	.end local v0

	.epilogue

.end method
