# Goal: Show how to explore, reorder, and select the data
# Author: Minghong SHEN
# Date: 2024-06-03
# Last update: 2024-06-09
# Import: all song officials vertex attributes.csv
# Export: None

pacman::p_load(tidyverse, statart)

# Load the data
# Downloaded from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/KER9GK
# Wang, Yuhua, 2021, "Replication Data for: The Rise and Fall of Imperial China: The Social Origins of State Development. Princeton University Press.", https://doi.org/10.7910/DVN/KER9GK, Harvard Dataverse, V1, UNF:6:L5nJpS44U2P6GvJeR7SThg== [fileUNF]
file <- "C:/Users/socim/Downloads/all song officials vertex attributes.csv"
tb <- read_data(file)

print_interval(tb)
glimpse(tb)
# view(tb)
variables(tb)
codebook(tb)
codebook(tb) %>% view()
codebook_detail(tb)
summ(tb)

tb |> glimpse()

arrange(tb, name_pinyin)
arrange(tb, name_fanti)
relocate(tb, hometown_county_name)
relocate(tb, hometown_county_name, .before = name_pinyin)
relocate(tb, hometown_county_name, .after = name_fanti)

# Use %>% to chain the functions
tb %>%
  arrange(name_fanti) %>%
  print_interval(20)

# Or use |> to chain the functions
tb |>
  arrange(name_fanti) |>
  print_interval(20)

tb |>
  arrange(hometown_county_name) |>
  relocate(hometown_county_name, .before = name_pinyin) |>
  print_interval(20)

tb |>
  arrange(hometown_county_name) |>
  relocate(hometown_county_name, .before = name_pinyin) |>
  glimpse()

summ(tb) |>
  print(n = Inf)


# Select the columns
names(tb)

# select all variables starting with "hometown"
tb %>%
  ds(c(hometown_code, hometown_county_pinyin:hometown_province_name))

tb %>%
  select(hometown_code:hometown_province_name) %>%
  ds(-c(office_startyear:fiscal_CBDB))

tb %>%
  ds(s_match("hometown*"))

tb %>%
  ds(starts_with("hometown"))

# select cohort10-cohort16
tb %>%
  ds(cohort10:cohort16)

tb %>%
  select(starts_with("cohort1")) %>%
  ds(-cohort1)

tb %>%
  ds(s_match("cohort1[0-6]"))

tb %>%
  ds(s_match("cohort1?"))

tb %>%
  ds(matches("cohort1."))

tb %>%
  ds(matches("cohort1[0-6]"))

tb %>%
  ds(matches("cohort1\\d"))


# select character variables
tb %>%
  select(where(is.character)) %>%
  glimpse()


# select the last column(s)
tb %>%
  select(last_col())

tb %>%
  select(last_col(1)) # select the 2nd last column

tb %>%
  select(last_col(2):last_col()) # select last 3 columns


# relocate in alphabetical order
names_sorted <- tb %>%
  names_as_column() %>%
  arrange(name) %>%
  pull(1)

tb %>%
  relocate(names_sorted)

tb %>%
  relocate(all_of(names_sorted))

tb %>%
  select(all_of(names_sorted))
