// Example method that causes an issue with indentation on usage
void someMethod(
  void onSuccess(),
  void onError(Exception ex, StackTrace stackTrace),
) {
  try {} catch (_, __) {}
}

void main() {
  someMethod(() {
  }, (Exception ex, StackTrace stackTrace) {
  });
}
