# install.packages("epubr")

pacman::p_load(tidyverse, statart, epubr)

tb <- epub("C:/Users/socim/Downloads/额尔古纳河右岸.epub")

book <- tb %>%
  pull(data) %>%
  .[[1]] %>%
  slice(2) %>%
  pull(text)

# Word count
word_count <- str_length(book)
word_count

# Number of paragraphs
book %>%
  str_count("\\n")

# Number of sentences
book %>%
  str_count("[。！？!?]")

book_vector <- book %>%
  str_remove("\\n申明.+第06期") %>%
  str_split_1("\\s\\n")

book_vector[1:20]

book_vector %>%
  map_dbl(~ str_count(.x, "[。！？!?]"))

book_vector[459:461]


keyword_tb <- book %>%
  str_locate_all("列娜") %>%
  .[[1]] %>%
  as_tibble() %>%
  mutate(
    location = row_mean(start:end) / word_count
  )

keyword_tb %>%
  mutate(
    y = floor(location * 100),
    x = location * 1e4 - y * 100
  ) %>%
  ggplot() +
  aes(x, -y) +
  geom_point(
    shape = 21, fill = "gray80", color = "black",
    size = 3
  ) +
  scale_y_continuous(
    breaks = seq(-100, 0, 20),
    labels = seq(100, 0, -20)
  ) +
  coord_equal(
    xlim = c(0, 100), ylim = c(-100, 0)
  ) +
  theme_bw() +
  labs(
    x = "% within section",
    y = "Section"
  )



# Write a function about this
keyword_plot <- function(keyword) {
  keyword_tb <- book %>%
    str_locate_all(keyword) %>%
    .[[1]] %>%
    as_tibble() %>%
    mutate(
      location = row_mean(start:end) / word_count
    )

  keyword_tb %>%
    mutate(
      y = floor(location * 100),
      x = location * 1e4 - y * 100
    ) %>%
    ggplot() +
    aes(x, -y) +
    geom_point(
      shape = 21, fill = "gray80", color = "black",
      size = 3
    ) +
    scale_y_continuous(
      breaks = seq(-100, 0, 20),
      labels = seq(100, 0, -20)
    ) +
    coord_equal(
      xlim = c(0, 100), ylim = c(-100, 0)
    ) +
    theme_bw() +
    labs(
      x = "% within section",
      y = "Section"
    )
}

keyword_plot("达玛拉")
keyword_plot("拉吉达")
keyword_plot("瓦罗加")
keyword_plot("马伊堪")
keyword_plot("马粪包")
