pacman::p_load(
  tidyverse,
  statart
)

# Examples below come from the official documentation:
# https://tidyr.tidyverse.org/articles/pivot.html#longer

relig_income

relig_income %>%
  pivot_longer(
    cols = !religion,
    names_to = "income",
    values_to = "count"
  )

billboard

billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )

who

who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = c("diagnosis", "gender", "age"),
    names_pattern = "new_?(.*)_(.)(.*)",
    values_to = "count"
  )
