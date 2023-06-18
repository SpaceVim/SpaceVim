void test() {
  switch(a) {
    case 1:
  }
}

void test() {
  switch(a) {
    default:
  }
}

void test_break_dedent() {
  switch(x) {
    case 1:
      break;
  }
  switch(y) {
    case 2:
      return;
  }
}


void test_multi_case() {
  switch(x) { 
    case 1:
    case 2:
  }
}
