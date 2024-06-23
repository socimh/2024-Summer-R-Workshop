install.packages("epubr")

pacman::p_load(tidyverse, statart, epubr)

tb <- epub("C:/Users/socim/Downloads/额尔古纳河右岸.epub")

book <- tb %>%
  pull(data) %>%
  .[[1]] %>%
  slice(2) %>%
  pull(text)

str_length(book)

book %>%
  str_count("\\n")

book_vector <- book %>%
  str_remove("\\n申明.+第06期") %>%
  str_split_1("\\s\\n")

book_vector[1:20]

book %>%
  str_count("[。！？!?]")

book_vector %>%
  map_dbl(~ str_count(.x, "[。！？!?]"))
