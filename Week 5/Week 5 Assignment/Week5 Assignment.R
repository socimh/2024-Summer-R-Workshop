# ================== Week 5 Assignment ==================#

# Question setter: Minghong SHEN
# Release date: 2024-07-02
#
# Test taker (名字):
# Import:
# Export:
# Completion date:



# ================== Question Set ==================#

# Use the shijing.json to answer the following questions.
# Please refer to Week 5-1. explore_shijing.R for the data import and cleaning.
file <- "C:/Users/socim/Downloads/shijing.json"
tb <- read_data(file) %>%
  unnest_longer(content) %>%
  mutate(
    paragraph = row_number(),
    .by = "title"
  )

# QUESTION 1. How many sentences are ending with "之" in Shijing?
tb %>%
  mutate(
    zhi_num = str_count(content, "之[。！？\\.\\?!]")
    ) %>%
  summarise(num = sum(zhi_num))

# QUESTION 2. Filter sentences with exactly two "，" and only one "。".
#             For example, "麟之趾，振振公子，于嗟麟兮。"
tb %>%
  filter(
    str_count(content, "，") == 2 &
    str_count(content, "。") == 1
  )

tb %>%
  # if stricter
  filter(
    str_detect(content, "^\\w+，\\w+，\\w+。$")
  )

# QUESTION 3. "ABAB" patterns (e.g., 委蛇委蛇) are most prevalent in which chapter of Shijing?
tb %>%
  mutate(
    abab_num = str_count(content, "(\\w{2})\\1")
  ) %>%
  summ(abab_num, .by = chapter) %>%
  arrange(-mean)

# QUESTION 4. How many "ABAC" patterns (e.g., 是刈是濩) are there in Shijing?
tb %>%
  mutate(
    abac_num = str_count(content, "(\\w)\\w\\1\\w")
  ) %>%
  summarise(sum(abac_num))
