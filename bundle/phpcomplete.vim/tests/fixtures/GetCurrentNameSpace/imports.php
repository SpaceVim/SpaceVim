<?php
namespace DontFindMe;
use RecursiveCallbackFilterIterator as RCFI; // lookup from the last line should not find this

namespace Foo;
use ArrayAccess; // simple bilt in class import
use ArrayObject as AO; // same with rename
use DateTime, DateTimeZone; // multiple import in one line
use Exception as E,
    LogicException as LE,
    ErrorException as EE; // multiple imports on multiple lines with renames

use NS1\SUBNS; // importing namespaces, the name will be the segment after the last \

use NS1\Foo; // imported class

// lets pretend we are here when completing
