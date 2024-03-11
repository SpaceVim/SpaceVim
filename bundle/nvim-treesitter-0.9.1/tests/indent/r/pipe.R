mtcars |>
  head(
    n = 6L
  ) |>
  subset(
    cyl > 3
  )

mtcars %>%
  head()
