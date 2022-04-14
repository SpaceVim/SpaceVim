try {
  throw Error()
} catch (err) {
  throw error
} finally {
  console.log("42")
}

