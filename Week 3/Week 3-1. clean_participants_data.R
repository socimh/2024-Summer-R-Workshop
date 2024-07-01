# Goal: Clean the participants data
# Import: participants_deidentified.csv
# Previous R scripts:
#       -  A1. preclean_participants_data.R
#       -  A2. translate_var_names.R
# Output: console output

# Load the required packages and the data
pacman::p_load(tidyverse, statart)

path <- "D:/R/Teaching/2024 Summer R Workshop/Week 3/participants_deidentified.csv"
tb <- read_data(path)
tb

# ===========================================================
##################### select columns #######################
# ===========================================================

tb %>% names()

# names() or ds() returns a "character vector"
# character vector is a vector of strings; i.e., some strings
# The "type" or "class" of a character vector is "character"
tb %>%
  names() %>%
  s_type()

# We did not learn how to edit vectors.
# If necessary, we can as_tibble() a character vector to a tibble
# Also, we can pull() a tibble column to a vector
tb %>%
  names() %>%
  as_tibble() # convert many types of objects to tibbles

tb %>% select(2)
tb %>% pull(2) # pull() extracts a column to a vector


# select() is used to select columns
tb %>%
  select(starts_with("learn"))
tb %>%
  select(s_match("learn*")) # equivalent to starts_with("learn")

tb %>%
  select(s_match("learn*")) %>%
  names()
tb %>%
  ds(s_match("learn*")) # ds() equals select(...) %>% names()


# ===========================================================
############## select rows based on conditions ##############
# ===========================================================

# filter() is used to select rows based on conditions
tb %>%
  filter(id > 50)

# Here, `id > 50` is a logical condition

# It is essentially a logical vector
pull(tb, id) > 50
s_type(pull(tb, id) > 50)
# ... but it is not necessary to understand this now.

# Other operators for creating logical conditions:
tb %>%
  filter(id <= 50)
tb %>%
  filter(id == 50)
tb %>%
  filter(clean_data_result == "未清洗")
tb %>%
  filter(clean_data_result != "未清洗") # ! and = lead to !=

31:50 # 31, 32, ..., 50
s_type(31:50)
tb %>%
  filter(id %in% 31:50) # discrete values
tb %>%
  filter(between(id, 31, 50)) # continuous values

# tb %>%
#   filter(prob_clean_data_invalid == NA) # this does not work
#
# NA means "Not Available" or "Not Applicable".
# A value is never equal to NA. Use is.na() instead.
tb %>%
  filter(is.na(prob_clean_data_invalid))
tb %>%
  filter(!is.na(prob_clean_data_invalid)) # ! means "not"

tb %>%
  filter(id >= 31 & id <= 50) # & means "and"
tb %>%
  filter(id >= 31 | is.na(prob_clean_data_invalid)) # | means "or"


# ===========================================================
############## select rows based on positions ##############
# ===========================================================

# select() can be used to select columns based on positions
tb %>%
  select(1:5) # first 5 columns
tb %>%
  select(c(1, 3, 5)) # 1st, 3rd, and 5th columns

# slice() is used to select rows based on positions
tb %>%
  slice(1:5) # first 5 rows
tb %>%
  slice(c(1, 3, 5)) # 1st, 3rd, and 5th rows

tb %>%
  slice_headtail()
tb %>%
  slice_interval()

tb %>%
  arrange(id) %>%
  slice_interval()

tb %>%
  slice_sample(n = 5)

tb %>%
  slice_sample(n = 5) %>%
  set_seed(20240618) # set_seed() for reproducibility


# ===========================================================
############## modify or create new columns ################
# ===========================================================


# mutate() is used to modify or create new columns
tb %>%
  mutate(id = id + 1000)
tb %>%
  mutate(id2 = id + 1000) %>%
  relocate(id, id2)

tb %>%
  mutate(
    id1 = id + 1000,
    id2 = id + 2000,
    id3 = id + 3000
  ) %>%
  relocate(s_match("id*"))

tb %>%
  select(s_match("software*"))

tb %>%
  mutate(
    software_spss = !is.na(software_spss),
    software_stata = !is.na(software_stata)
  ) %>%
  relocate(s_match("software*"))


# Iterate over columns (advanced topic)
tb %>%
  mutate(
    across( # across() iterates over columns
      s_match("software*"), # select columns
      ~ !is.na(.) # ~ helps to define a function
    )
  ) %>%
  relocate(s_match("software*"))

tb %>%
  mutate(
    clean_data_result = na_if_value(clean_data_result, "未清洗"),
    prob_clean_data_invalid =
      value_if_na(prob_clean_data_invalid, FALSE)
  )

tb %>%
  mutate(
    id_4g = cut_quantile(id),
    id_5g = cut_quantile(id, 5)
  ) %>%
  tab(id_5g)

tb %>%
  mutate(
    id_6g = cut_breaks(
      id,
      breaks = c(10, 20, 30, 40, 50)
    )
  ) %>%
  tab(id_6g)

# If you really want to update the data, use the assignment operator <-
tb <- tb %>%
  mutate(
    id_6g = cut_breaks(
      id,
      breaks = c(10, 20, 30, 40, 50)
    )
  )

# Three forms of the same thing
c(10, 20, 30, 40, 50)
seq(10, 50, 10)
1:5 * 10

tb %>%
  tab(id_6g)


# Binary variables
c(TRUE, FALSE, TRUE) # logical vector
# Categorical variables
factor(1:3, labels = c("Disagree", "Neutral", "Agree"))

tmp_tb <- tibble(
  x = factor(c(1:3, 3), labels = c("Disagree", "Neutral", "Agree")),
  y = 1:4
)

tmp_tb
tmp_tb %>%
  regress_coef(y ~ x)

# ===========================================================
################### Get summary statistics ##################
# ===========================================================

# summ() is used for continuous variables
tb %>% summ()
tb %>% summ(duration) # only for the duration column
tb %>%
  tabstat(duration, .by = country)

tb %>%
  # Remove the outlier
  filter(duration < 10000) %>%
  # Convert the duration from seconds to minutes
  mutate(
    duration = duration / 60
  ) %>%
  summ(duration)

tb %>%
  summarise(
    mean_duration = mean(duration),
    sd_duration = sd(duration)
  )


# ===========================================================
# Quickly plot a histogram of the duration by using s_plot()
tb %>%
  filter(duration < 10000) %>%
  mutate(
    duration = duration / 60
  ) %>%
  # Plot the histogram
  s_plot(duration)

# ===========================================================
# tab() is used for categorical variables
tb %>%
  tab(clean_data_result)
tb %>%
  tab(province)
tb %>%
  tab(country, province)

tb %>%
  tab1(country, province)

tb %>%
  tab2(country, province)
tb %>%
  tab2(province, country)

# ===========================================================
# fre() converts the output to a flextable
tb %>%
  fre(country, province)

tb %>%
  fre1(country, province)

tb %>%
  fre2(province, country)

# See https://socimh.github.io/statart/reference/tab.html
# for more information on tab() and fre() functions
