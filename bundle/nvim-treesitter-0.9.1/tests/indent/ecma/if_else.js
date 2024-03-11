if (cond1) {
  do_1()

  if (cond1a) {
    do_1a()
  } else {
    do_1_fallback()
  }
} else if (cond2) {
  do_2()
} else {
  do_fallback()
}
