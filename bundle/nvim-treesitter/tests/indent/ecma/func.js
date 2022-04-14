const arrow_func = (
  a,
  b,
  c
) => {
  log(a, b, c)
}

const arrow_func_without_brace = (a, b, c) =>
  log(
    a,
    b,
    c
  )

function func_def(
  a,
  b,
  { c = '' }
) {
  log(a, b, c)
}

func_call(
  a,
  (b) => b
)

chained_func_call()
  .map()
  .filter()

func_call(
  chained_func_call()
    .map()
    .filter()
)

function prepare_list_fetcher(filter) {
  return Object.assign(
    async () =>
      (
        await http.get('/list', {
          params: {
            filter: filter,
          },
        })
      ).data,
    { key: ['/list', filter] }
  )
}
