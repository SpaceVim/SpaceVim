class Something {
  final int number;
  final Function(int) write;

  Something(this.number, this.write);
}

void test() {
  Something(
    1,
    (int number) {
  );
}
