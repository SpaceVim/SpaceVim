class Box<T> {
  //      ^ type
  //   ^ type
  protected T $data;
  // ^ type.qualifier
  //        ^ type

  public function __construct(T $data) {
  //                          ^ type
  //                             ^ parameter
  //        ^ keyword.function
  // ^ type.qualifier
  //                    ^ method
    $this->data = $data;
  }

  public function getData(): T {
                // ^ method
  // ^ type.qualifier
    return $this->data;
              // ^ operator
          // ^ variable.builtin
  }
}
