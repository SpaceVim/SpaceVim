.class public Lbaksmali/test/class;
.super Ljava/lang/Object;

.source "baksmali_test_class.smali"

.method public testMethod(ILjava/lang/String;)Ljava/lang/String;
	.registers 3
	.annotation runtime Lorg/junit/Test;
	.end annotation
	.annotation system Lyet/another/annotation;
		somevalue = 1234
		anothervalue = 3.14159
	.end annotation

	const-string v0, "testing\n123"

	goto switch:

	sget v0, Lbaksmali/test/class;->staticField:I

	switch:
	packed-switch v0, pswitch:

	try_start:
	const/4 v0, 7
	const v0, 10
	nop
	try_end:
	.catch Ljava/lang/Exception; {try_start: .. try_end:} handler:
	.catchall {try_start: .. try_end:} handler2:

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
