class Box<T> {
  //      ^ type
  //   ^ type
  protected T $data;
  // ^ keyword
  //        ^ type

  public function __construct(T $data) {
  //                          ^ type
  //                             ^ parameter
  //        ^ keyword.function
  // ^ keyword
  //                    ^ method
    $this->data = $data;
  }

  public function getData(): T {
                // ^ method
  // ^ keyword
    return $this->data;
              // ^ operator
          // ^ variable.builtin
  }
}
