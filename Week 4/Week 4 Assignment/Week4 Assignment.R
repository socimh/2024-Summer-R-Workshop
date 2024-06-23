# ================== Week 4 Assignment ==================#

# Question setter: Minghong SHEN
# Release date: 2024-06-25
#
# Test taker (名字):
# Import:
# Export:
# Completion date:



# ===========================================================
##################### prepare the data ######################
# ===========================================================

# Load the required packages and the data
pacman::p_load(
  tidyverse, statart, showtext
)

# If you want to insert Chinese characters, load 'showtext';
# otherwise, do not load it.
showtext_auto()
showtext_opts(dpi = 300)

run <- read_data(
  "D:/R/Teaching/2024 Summer R Workshop/Week 4/Week 4 Assignment/汉马逐公里数据.xlsx",
) %>%
  # clean some variables
  mutate(
    distance = parse_number(distance),
    segment = distance - lag(distance, default = 0),
    pace = str_remove(pace, "min/km") %>% ms(),
    elevation_up = str_extract(elevation, "(?<=\\+)\\d+") %>%
      parse_number(),
    elevation_down = str_extract(elevation, "(?<=\\-)\\d+") %>%
      parse_number(),
    elevation = NULL,
    power = parse_number(power),
    elevation = elevation_up - elevation_down,
    speed = 1000 / as_numeric(pace)
  )


# ===========================================================
#################### data visualization ###################
# ===========================================================

# Week 4-3.R provides many examples of visualizing the data.
# Refer to that script and complete the following questions.

# ================== Question Set ==================#

# QUESTION 1. Plot the distribution of ground_contact
# QUESTION 2. Plot the relationship between speed and power
# QUESTION 3. Plot the relationship between stride_length and speed

# QUESTION 4. Plot the relationship between distance and speed, and
#             the filling color is the value of heart_rate.
#             Make sure the final plot is nice-looking and publishable.
