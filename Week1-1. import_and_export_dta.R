# Goal: Demo how to import and export data
# Author: Minghong SHEN
# Date: 2024-05-25
# Last update: 2024-05-25
# Import: sample_data.dta
# Export: sample_data_cleaned.ftr

# Load the necessary packages
library(haven)
library(tidyverse)
library(statart)
library(arrow)

# Load the sample data
root <- getwd() # Change this to your own directory
path <- root |>
  file.path("sample_data.dta")

tb <- read_dta(path)

s_print(tb)
summ(tb)

tb <- tb |>
  mutate(
    a1 = a + 1,
    b2 = b * 2
  )
s_print(tb)

# Export the data to a .ftr file
write_feather(tb, "sample_data_cleaned.ftr")
