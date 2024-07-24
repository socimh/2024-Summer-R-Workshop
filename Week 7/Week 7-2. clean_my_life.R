pacman::p_load(
  tidyverse, statart
)

raw_data <- read_data(
  "D:/Health/饮食运动表 仅教学.xlsx",
                      range = "B2:AC36"
  )

num_to_date <- function(x, suffix) {
  x %>%
    as.numeric() %>%
    as.Date(origin = "1899-12-30") %>%
    paste0(suffix)
}

1:10 %% 2
1:10 %% 2 == 1

raw_names <- raw_data %>% names()
date_names <- map_chr(
  1:length(raw_names),
  ~ if_else(
    .x %% 2 == 1,
    num_to_date(raw_names[.x], " Food"),
    num_to_date(raw_names[.x - 1], " Note")
  )
) %>%
  suppressWarnings()

raw_data <- raw_data %>%
  rename_with(~ date_names)


raw_travel_data <- raw_data %>%
  pivot_longer(
    cols = everything(),
    names_to = "date",
    values_to = "travel"
  ) %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    travel = str_extract(travel, "^[来回去到]\\w{2,3}$")
  )

raw_travel_data %>%
  filter(!is.na(travel)) %>%
  arrange(date)

travel_data <- raw_travel_data %>%
  distinct(date) %>%
  left_join(
    raw_travel_data %>%
      filter(!is.na(travel)),
    by = "date"
  ) %>%
  mutate(
    travel = if_else(
      row_number() == 1,
      "深圳",
      str_remove_all(travel, "^[来回去到]")
    )
  ) %>%
  fill(travel, .direction = "down") %>%
  rename(city = travel) %>%
  mutate(
    lag_date = lag(date),
    lag_city = lag(city)
  ) %>%
  mutate(
    travel = lag_date != date & lag_city != city,
    date0 = if_else(travel, date, NA_Date_),
    city0 = ifelse(travel, lag_city, NA)
  ) %>%
  select(date, city, date0, city0) %>%
  pivot_longer(
    cols = c(date0, date),
    names_to = "type",
    values_to = "date"
  ) %>%
  filter(!is.na(date)) %>%
  mutate(
    city = if_else(
      type == "date0",
      city0,
      city
    )
  ) %>%
  select(date, city)

# draw the travel history
travel_data %>%
  group_by(date) %>%
  summarise(
    city = str_c(city, collapse = " -> ")
  ) %>%
  filter(str_detect(city, "->"))

# count # of days in each city
travel_data %>%
  group_by(date) %>%
  mutate(
    city_day = 1 / n()
  ) %>%
  ungroup() %>%
  group_by(city) %>%
  summarise(
    days = sum(city_day),
    last_visit = max(date)
  ) %>%
  arrange(desc(days))

where_am_i <- function(date_str) {
  travel_data %>%
    filter(date == as.Date(date_str)) %>%
    pull(city)
}

# find the location in a certain date
where_am_i("2024-02-01")
