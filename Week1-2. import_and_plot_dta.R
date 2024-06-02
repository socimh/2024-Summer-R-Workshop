# Goal: Demo how to import and plot data
# Author: Minghong SHEN
# Date: 2024-05-25
# Last update: 2024-05-25
# Import: sample_data.dta
# Export: sample_data_plot.png

# Load the necessary packages
library(haven)
library(tidyverse)
library(statart)

# Load the sample data
root <- getwd() |> file.path("Sample Data") # Change this to your own directory
path <- root |>
  file.path("sample_data.dta")

tb <- read_dta(path)

s_print(tb)
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

out_path <- root |>
  file.path("sample_data_plot.png")

ggsave(out_path, gg, width = 6, height = 4, dpi = 300, units = "in")
