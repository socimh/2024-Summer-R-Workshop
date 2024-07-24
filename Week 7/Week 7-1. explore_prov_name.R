# Goal: Explore province names
# Import: 省份名称.xlsx
# Source: https://github.com/Ivysauro/CNRT/blob/master/data/Name.md
# Output: console output

# Load the required packages and the data
pacman::p_load(tidyverse, statart)

path <- "D:/R/Teaching/2024 Summer R Workshop/Week 7/省份名称.xlsx"
tb <- read_data(path)


# ===========================================================
########### Convert the Unit of Analysis to 简称 ############
# ===========================================================

varnames <- tb %>% names()
tidy_varnames <- varnames %>%
  str_extract("/.+$") %>%
  str_remove("/ ") %>%
  janitor::make_clean_names()

tb <- tb %>%
  rename_with(~tidy_varnames)

tb %>%
  pull(short_name)

# origin_of_short_name is related to the short name
tb %>% filter(chinese_name == "上海")
# E.g., 古称，沪渎/封地，春申君 is related to 沪/申,
# because 古称，沪渎 -> 沪, 封地，春申君 -> 申

split_tb <- tb %>%
  mutate(
    short_name = str_split(short_name, "[/或]"),
    origin_of_short_name = str_split(origin_of_short_name, "[/或]")
  )

tibble(a = 1) %>% s_type()
list(a = 1, b = tibble(a = 1)) %>% class()

split_tb %>%
  slice(9) %>%
  pull(short_name)

unnest_tb1 <- split_tb %>%
  unnest_longer(short_name) %>%
  mutate(
    short_name_id = row_number(),
    .by = "chinese_name"
  )

unnest_tb1 %>%
  relocate(short_name_id)

unnest_tb2 <- split_tb %>%
  unnest_longer(origin_of_short_name) %>%
  mutate(
    short_name_id = row_number(),
    .by = "chinese_name"
  ) %>%
  select(-short_name)

unnest_tb2 %>%
  relocate(short_name_id)

abbr_tb <- unnest_tb1 %>%
  select(chinese_name, short_name, short_name_id) %>%
  left_join(unnest_tb2, by = c("chinese_name", "short_name_id")) %>%
  select(-short_name_id) %>%
  filter(chinese_name != short_name) %>%
  mutate(
    origin_of_short_name = value_if_na(origin_of_short_name, "缩略")
  )

abbr_tb %>%
  print(n = Inf)

tb %>%
  filter(origin_of_short_name == "缩略") %>%
  print(n = Inf)

abbr_tb %>%
  filter(origin_of_short_name == "缩略") %>%
  print(n = Inf)

abbr_tb %>%
  mutate(
    source = case_when(
      str_detect(origin_of_short_name, "缩略") ~ "缩略",
      str_detect(origin_of_short_name, "古") ~ "古称",
      str_detect(origin_of_short_name, "[山河]") ~ "山河",
      str_detect(origin_of_short_name, "封地") ~ "封地"
    )
  ) %>%
  # tab(source, .desc = TRUE)
  relocate(source, .after = origin_of_short_name) %>%
  print(n = Inf)
