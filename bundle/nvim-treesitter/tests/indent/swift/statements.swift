func Test() {
  if true {
    return
  } else if true {
    return
  }

  switch x {
  case "1":
    print("x")
  default:
    print("y")
  @unknown default:
    print("z")
  }

  for a in b {
  }

  while true{
  }

  repeat {

  } while (true)

  guard let name = person["name"] else {
    return
  }

  return (
    x + 1
  )
}
