class IndentTest {
  async isEqual(paramOne, paramTwo) {
    if (paramOne === paramTwo) {
      return true
    }

    return false
  }

  async isNotEqual(
    paramOne,
    paramTwo,
  ) {
    if (paramOne !== paramTwo) {
      return true
    }

    return false
  }
}
