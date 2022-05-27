foreach (($array as vec[]) as $item) {}
// ^ repeat
//                   ^ type

# Our expectation test for the code below intentionally includes an ERROR.
foreach ($array as vec[] as $item) {}
