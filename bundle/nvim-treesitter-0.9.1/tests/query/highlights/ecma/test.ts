class H {
  pub_field = "Hello";
  //  ^ property

  #priv_field = "World!";
  //   ^ property

  #private_method() {
    //  ^ method
    return `${this.pub_field} -- ${this.#priv_field}`;
    //                                      ^ property
    //                ^ property
  }

  public_method() {
    //  ^ method
    return this.#private_method();
    //                ^ method.call
  }

  ok() {
    return this.public_method();
    //                ^ method.call
  }
}

function doSomething(options) {
  const {
    enable: on,
    //    ^ punctuation.delimiter
  } = options
}
