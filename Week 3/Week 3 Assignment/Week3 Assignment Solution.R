# ================== Week 3 Assignment ==================#

# Question setter: Minghong SHEN
# Release date: 2024-06-18
#
# Test taker (名字):
# Import:
# Export:
# Completion date:



# ================== Question Set ==================#

###### Load the necessary packages ######
# QUESTION 1. Load tidyverse and statart packages
pacman::p_load(tidyverse, statart)

###### Explore starwars data ######
# QUESTION 2. Print the built-in dataset of tidyverse "starwars".
starwars

# QUESTION 2a. Only keep the characters whose eye color is blue.
starwars %>%
  filter(eye_color == "blue")

# QUESTION 2b. Only keep the characters whose eye, skin, and hair colors are the same.
starwars %>%
  filter(eye_color == skin_color & skin_color == hair_color) %>%
  filter(hair_color != "unknown")

# QUESTION 2c. What is the average height of the characters whose hair color is black?
starwars %>%
  filter(hair_color == "black") %>%
  summ(height)

# QUESTION 2d. Randomly select 5 male characters and view() their characteristics.
starwars %>%
  filter(sex == "male") %>%
  slice_sample(n = 5) %>%
  view() %>%
  set_seed(20240625)

# QUESTION 2e. Compare the age (in 2024) of characters across gender.
starwars %>%
  mutate(age = 2024 - birth_year) %>%
  summ(age, .by = gender)

starwars %>%
  mutate(age = 2024 - birth_year) %>%
  filter(gender == "masculine") %>%
  summ(age)

starwars %>%
  mutate(age = 2024 - birth_year) %>%
  filter(gender == "feminine") %>%
  summ(age)


# QUESTION 2f. What are the top 3 most common homeworlds?
starwars %>%
  tab(homeworld) %>%
  arrange(-n) %>%
  filter(!is.na(homeworld)) %>%
  head(3)

starwars %>%
  tab(homeworld, .desc = TRUE) %>%
  filter(!is.na(homeworld)) %>%
  head(3)

starwars %>%
  tab(homeworld, .desc = TRUE) %>%
  filter(!is.na(homeworld)) %>%
  head(5)
