
#! 7 import-error
import not_existing

import os

from os.path import abspath
#! 20 import-error
from os.path import not_existing

from datetime import date
date.today

#! 5 attribute-error
date.not_existing_attribute

#! 14 import-error
from datetime.date import today

#! 16 import-error
import datetime.datetime
#! 7 import-error
import not_existing_nested.date

import os.path
