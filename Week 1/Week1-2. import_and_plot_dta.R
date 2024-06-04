# Goal: Demo how to import and plot data
# Author: Minghong SHEN
# Date: 2024-05-25
# Last update: 2024-06-03
# Import: sample_data.dta
# Export: sample_data_plot.png

# Load the necessary packages
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
codebook(tb)
summ(tb)

gg <- tb |>
  ggplot() +
  aes(d, a) +
  geom_point() +
  geom_smooth(
    method = "lm",
    color = "yellow",
    linetype = "dashed"
  )

# Change it to your own directory
out_path <- getwd() %>%
  file.path("Week 1/sample data/sample_data_plot.png")

ggsave(out_path, gg, width = 6, height = 4, dpi = 300, units = "in")
