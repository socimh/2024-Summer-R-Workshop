# ================== Week 2 Assignment ==================#

# Question setter: Minghong SHEN
# Release date: 2024-06-11
#
# Test taker (名字):
# Import:
# Export:
# Completion date:



# ================== Question Set ==================#

###### Load the necessary packages ######
# QUESTION 1. Load tidyverse and statart packages
pacman::p_load(tidyverse, statart)


###### Explore storms data ######
# QUESTION 2. Print the built-in dataset of tidyverse "storms".
data(storms)
storms

# QUESTION 2a. Sort the dataset by date (i.e., year + month + day + hour) and then print_interval().
storms %>%
  arrange(year, month, day, hour) %>%
  print_interval()

storms %>%
  arrange(year, month, day, hour) %>%
  print_headtail()

# QUESTION 2b. Only keep the storm "Dennis" and only keep numeric variables.
storms %>%
  filter(name == "Dennis") %>%
  select(name, where(is.numeric))


###### Import Hubei 2020 Data ######
# Note: attributes.csv lists the variable labels of the dataset.
# Both csv files are downloaded from https://github.com/beoutbreakprepared/nCoV2019.

# QUESTION 3. Import the dataset "hubei_20200301.csv" as "tb"
path <- "D:/R/Teaching/2024 Summer R Workshop/Week 2/Week 2 Assignment"
tb <- file.path(path, "hubei_20200301.csv") %>%
  read_csv()
tb
glimpse(tb)

# QUESTION 3a. Print the codebook of the dataset with all variables.
codebook(tb) %>%
  print(n = Inf)
codebook(tb) %>%
  print(n = 32)

# QUESTION 3b. According to the "attributes.csv", select all variables that
#              are related to the location and sort them in alphabetical order.
dict <- file.path(path, "attributes.csv") %>%
  read_csv()
dict
view(dict)

tb %>%
  select(
    starts_with("admin"),
    country_new, geo_resolution,
    latitude, longitude, travel_history_location
  ) %>%
  relocate(admin1, admin2)
