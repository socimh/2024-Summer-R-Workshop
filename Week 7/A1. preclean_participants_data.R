# You do not need to run this script.
# It is used to pre-clean the data and remove any identifying information
# before sharing it with the workshop participants.
#########################################################################

pacman::p_load(tidyverse, statart)

# Load data
file <- "C:/Users/socim/Downloads/participants_survey_text.csv"
participants_text <- read_data(file)

# Load a local function
getwd() %>%
  paste0("/Workshop Surveys Analysis/A2. translate_var_names.R") %>%
  source()

participants_text <- participants_text |>
  translate_var_names()

participants_deidentified <- participants_text |>
  select(-c(
    user_type, user_id, nickname, custom_field,
    ip, referrer, suggestions
  )) |>
  select(-last_col()) |>
  select(-s_match("*fill"))

getwd() %>%
  paste0("/Workshop Surveys Analysis/participants_deidentified.csv") %>%
  write_data(participants_deidentified, .)
