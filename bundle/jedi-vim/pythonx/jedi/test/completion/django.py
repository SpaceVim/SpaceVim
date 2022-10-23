import datetime
import decimal
import uuid

from django.db import models
from django.contrib.auth.models import User
from django.db.models.query_utils import DeferredAttribute


class TagManager(models.Manager):
    def specially_filtered_tags(self):
        return self.all()


class Tag(models.Model):
    tag_name = models.CharField()

    objects = TagManager()

    custom_objects = TagManager()


class Category(models.Model):
    category_name = models.CharField()


class AttachedData(models.Model):
    extra_data = models.TextField()


class BusinessModel(models.Model):
    attached_o2o = models.OneToOneField(AttachedData)

    category_fk = models.ForeignKey(Category)
    category_fk2 = models.ForeignKey('Category')
    category_fk3 = models.ForeignKey(1)
    category_fk4 = models.ForeignKey('models')
    category_fk5 = models.ForeignKey()

    integer_field = models.IntegerField()
    big_integer_field = models.BigIntegerField()
    positive_integer_field = models.PositiveIntegerField()
    small_integer_field = models.SmallIntegerField()
    char_field = models.CharField()
    text_field = models.TextField()
    email_field = models.EmailField()
    ip_address_field = models.GenericIPAddressField()
    url_field = models.URLField()
    float_field = models.FloatField()
    binary_field = models.BinaryField()
    boolean_field = models.BooleanField()
    decimal_field = models.DecimalField()
    time_field = models.TimeField()
    duration_field = models.DurationField()
    date_field = models.DateField()
    date_time_field = models.DateTimeField()
    uuid_field = models.UUIDField()
    tags_m2m = models.ManyToManyField(Tag)

    unidentifiable = NOT_FOUND

    #? models.IntegerField()
    integer_field

    def method(self):
        return 42

# -----------------
# Model attribute inference
# -----------------

#? DeferredAttribute()
BusinessModel.integer_field
#? DeferredAttribute()
BusinessModel.tags_m2m
#? DeferredAttribute()
BusinessModel.email_field

model_instance = BusinessModel()

#? int()
model_instance.integer_field
#? int()
model_instance.big_integer_field
#? int()
model_instance.positive_integer_field
#? int()
model_instance.small_integer_field
#? str()
model_instance.char_field
#? str()
model_instance.text_field
#? str()
model_instance.email_field
#? str()
model_instance.ip_address_field
#? str()
model_instance.url_field
#? float()
model_instance.float_field
#? bytes()
model_instance.binary_field
#? bool()
model_instance.boolean_field
#? decimal.Decimal()
model_instance.decimal_field
#? datetime.time()
model_instance.time_field
#? datetime.timedelta()
model_instance.duration_field
#? datetime.date()
model_instance.date_field
#? datetime.datetime()
model_instance.date_time_field
#? uuid.UUID()
model_instance.uuid_field

#! ['attached_o2o = models.OneToOneField(AttachedData)']
model_instance.attached_o2o
#! ['extra_data = models.TextField()']
model_instance.attached_o2o.extra_data
#? AttachedData()
model_instance.attached_o2o
#? str()
model_instance.attached_o2o.extra_data

#! ['category_fk = models.ForeignKey(Category)']
model_instance.category_fk
#! ['category_name = models.CharField()']
model_instance.category_fk.category_name
#? Category()
model_instance.category_fk
#? str()
model_instance.category_fk.category_name
#? Category()
model_instance.category_fk2
#? str()
model_instance.category_fk2.category_name
#?
model_instance.category_fk3
#?
model_instance.category_fk4
#?
model_instance.category_fk5

#? models.manager.RelatedManager()
model_instance.tags_m2m
#? Tag()
model_instance.tags_m2m.get()
#? ['add']
model_instance.tags_m2m.add

#?
model_instance.unidentifiable
#! ['unidentifiable = NOT_FOUND']
model_instance.unidentifiable

#? int()
model_instance.method()
#! ['def method']
model_instance.method

# -----------------
# Queries
# -----------------

#? ['objects']
model_instance.object
#?
model_instance.objects
#?
model_instance.objects.filter
#? models.query.QuerySet.filter
BusinessModel.objects.filter
#? BusinessModel() None
BusinessModel.objects.filter().first()
#? str()
BusinessModel.objects.get().char_field
#? int()
BusinessModel.objects.update(x='')
#? BusinessModel()
BusinessModel.objects.create()

# -----------------
# Custom object manager
# -----------------

#? TagManager()
Tag.objects
#? Tag() None
Tag.objects.filter().first()

#? TagManager()
Tag.custom_objects
#? Tag() None
Tag.custom_objects.filter().first()

# -----------------
# Inheritance
# -----------------

class Inherited(BusinessModel):
    text_field = models.IntegerField()
    new_field = models.FloatField()

inherited = Inherited()
#? int()
inherited.text_field
#? str()
inherited.char_field
#? float()
inherited.new_field

#?
Inherited.category_fk2.category_name
#? str()
inherited.category_fk2.category_name
#? str()
Inherited.objects.get().char_field
#? int()
Inherited.objects.get().text_field
#? float()
Inherited.objects.get().new_field

# -----------------
# Model methods
# -----------------

#? ['from_db']
Inherited.from_db
#? ['validate_unique']
Inherited.validate_uniqu
#? ['validate_unique']
Inherited().validate_unique

# -----------------
# Django Auth
# -----------------

#? str()
User().email
#? str()
User.objects.get().email

# -----------------
# values & values_list (dave is too lazy to implement it)
# -----------------

#?
BusinessModel.objects.values_list('char_field')[0]
#? dict()
BusinessModel.objects.values('char_field')[0]
#?
BusinessModel.objects.values('char_field')[0]['char_field']

# -----------------
# Completion
# -----------------

#? 19 ['text_field=']
Inherited(text_fiel)
#? 18 ['new_field=']
Inherited(new_fiel)
#? 19 ['char_field=']
Inherited(char_fiel)
#? 19 ['email_field=']
Inherited(email_fie)
#? 19 []
Inherited(unidentif)
#? 21 ['category_fk=', 'category_fk2=', 'category_fk3=', 'category_fk4=', 'category_fk5=']
Inherited(category_fk)
#? 21 ['attached_o2o=']
Inherited(attached_o2)
#? 18 ['tags_m2m=']
Inherited(tags_m2m)

#? 32 ['tags_m2m=']
Inherited.objects.create(tags_m2)
#? 32 ['tags_m2m=']
Inherited.objects.filter(tags_m2)
#? 35 ['char_field=']
Inherited.objects.exclude(char_fiel)
#? 34 ['char_field=']
Inherited.objects.update(char_fiel)
#? 32 ['email_field=']
Inherited.objects.get(email_fiel)
#? 44 ['category_fk2=']
Inherited.objects.get_or_create(category_fk2)
#? 44 ['uuid_field=']
Inherited.objects.update_or_create(uuid_fiel)
#? 48 ['char_field=']
Inherited.objects.exclude(pk=3).filter(char_fiel)
