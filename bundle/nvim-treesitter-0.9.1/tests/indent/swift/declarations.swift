@wrapper
@modifier(
  *
)
class EquilateralTriangle: NamedShape {
  var sideLength: Double = 0.0

  @attr
  init(
    sideLength: Double, 
    name: String
  ) {
    self.sideLength = sideLength
  }

  var perimeter: Double {
    willSet {
    }
  }

  @funcattr
  override func simpleDescription(a: int, b: int) -> String {
    return "An equilateral triangle with sides of length \(sideLength)."
  }
}

@attr
protocol ExampleProtocol {
  var simpleDescription: String { get }
  mutating func adjust()
}

@available(*)
func test() {

}

@attr(*)
typealias Foo = Bar

@attr
struct Foo<
  Bar
> {
  @Provider
  var test = 1

  subscript(index: Int) -> Int {
    var foo = 2
  }
}
