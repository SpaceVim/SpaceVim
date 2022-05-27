pub type Cat {
  Cat(name: String, cuteness: Int)
}

type User {
  LoggedIn(name: String)
  Guest
}

pub opaque type Counter {
  Counter(value: Int)
}

pub type Headers =
  List(#(String, String))

type Headers =
  List(#(String, String))
