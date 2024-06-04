# Goal: Demo how to import and export data
# Author: Minghong SHEN
# Date: 2024-05-25
# Last update: 2024-06-03
# Import: sample_data.dta
# Export: sample_data_cleaned.ftr

# Load the necessary packages
library(haven)
library(tidyverse)
library(statart)

# Load the sample data
# Change it to your own directory
# There are many ways to specify the path
path <- getwd() %>%
  file.path("Week 1/Sample Data/sample_data.dta")

tb <- read_data(path)
# tb <- read_dta(path) # equivalent

print_interval(tb)
codebook(tb) # codebook *, c in Stata
summ(tb) # summ * in Stata

tb <- tb |>
  mutate(
    a1 = a + 1,
    b2 = b * 2
  )
print_interval(tb)

# .ftr is a feather file (轻如鸿毛)
# Export the data to a .ftr file
write_data(tb, "sample_data_cleaned.ftr")
# write_feather(tb, "sample_data_cleaned.ftr") # equivalent
