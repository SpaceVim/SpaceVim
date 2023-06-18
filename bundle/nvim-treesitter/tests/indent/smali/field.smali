.class public Lbaksmali/test/class;
.super Ljava/lang/Object;

.source "baksmali_test_class.smali"

.field public static annotationStaticField:Lsome/annotation; = .subannotation Lsome/annotation;
	value1 = "test"
	value2 = .subannotation Lsome/annotation;
		value1 = "test2"
		value2 = Lsome/enum;
	.end subannotation
.end subannotation
