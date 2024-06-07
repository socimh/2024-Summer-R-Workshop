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

