

pacman::p_load(tidyverse, statart)

# Load the data
# Downloaded from https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/TPR4VU/VQVTQQ&version=3.0
# Wang, Yuhua, 2020, "2011.xlsx", Chinese Listed Firms Personnel Database, https://doi.org/10.7910/DVN/TPR4VU/VQVTQQ, Harvard Dataverse, V3
# Wang, Yuhua, 2020, "Chinese Listed Firms Personnel Database", https://doi.org/10.7910/DVN/TPR4VU, Harvard Dataverse, V3, UNF:6:WkXSf3F2h0PA4/fYOUpepA== [fileUNF]
file <- "C:/Users/socim/Downloads/2011.xlsx"
tb2011 <- read_data(file)

# Data cleaning
glimpse(tb2011)

tb2011 %>%
  tab(starts_with("..."))

tb2011 <- tb2011 %>%
  select(-starts_with("...")) %>%
  glimpse()

tb2011 %>%
  arrange(任职日期) %>%
  print_interval(20)

tb2011 %>%
  mutate(
    digits = log10(任职日期) %>% ceiling()
  ) %>%
  tab(digits, .desc = TRUE)
