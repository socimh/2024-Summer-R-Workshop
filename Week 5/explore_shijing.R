pacman::p_load(tidyverse, statart)

# Load the data
# Downloaded from https://github.com/chinese-poetry/chinese-poetry/blob/master/%E8%AF%97%E7%BB%8F/shijing.json
file <- "C:/Users/socim/Downloads/shijing.json"
tb <- read_data(file)

# Data cleaning
glimpse(tb)

tb <- tb %>%
  unnest_longer(content) %>%
  mutate(
    paragraph = row_number(),
    .by = "title"
  )

tb %>%
  filter(content %>% str_detect("嗟"))
