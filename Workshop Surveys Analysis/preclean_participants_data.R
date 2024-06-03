pacman::p_load(tidyverse, vroom, statart)

# Load data
getwd()
folder <- "D:/R/Teaching/2024 Summer R Workshop"

list.files(folder)
files <- list.files(folder, pattern = "^participants_survey_.*.csv$")
files

path1 <- paste0(folder, "/", files[1])
path2 <- paste0(folder, "/", files[2])


# participants_code <- vroom(path1)
# participants_code
# participants_code |>
#   select(16:20) |>
#   glimpse()
participants_text <- vroom(path2)

translate_var_names <- function(tb) {
  tb |>
  rename(
    id = 1, 
    clean_data_result = 2, 
    prob_clean_data_invalid = 3, 
    start_time = 4, 
    end_time = 5,
    duration = 6,
    country = 7, 
    province = 8,
    city = 9,
    user_type = 10, 
    user_id = 11,
    nickname = 12,
    custom_field = 13,
    ip = 14,
    ua = 15,
    referrer = 16,
    stage = 17,
    school = 18,
    school_fill = 19,
    major = 20,
    major_fill = 21, 
    software_none = 22, 
    software_spss = 23,
    software_stata = 24,
    software_r = 25,
    software_python = 26,
    software_javascript = 27,
    software_cpp = 28,
    software_gis = 29,
    learn_ggplot_none = 30,
    learn_ggplot_basic = 31,
    learn_ggplot_color = 32,
    learn_ggplot_advanced = 33,
    learn_ggplot_other = 34,
    learn_ggplot_other_fill = 35, 
    learn_r_all = 36,
    learn_r_categorical = 37,
    learn_r_datetime = 38,
    learn_r_text = 39,
    learn_r_messy = 40,
    learn_r_highdim = 41,
    learn_r_spatial = 42,
    learn_r_network = 43,
    learn_r_stargazer = 44,
    learn_r_mapmodel = 45,
    learn_r_officer = 46,
    learn_r_other = 47,
    learn_r_other_fill = 48,
    unavailable_none = 49,
    unavailable_mon = 50,
    unavailable_tue = 51,
    unavailable_wed = 52,
    unavailable_thu = 53,
    unavailable_fri = 54,
    suggestions = 55
  )
}

# participants_code <- participants_code |>
#   translate_var_names()

participants_text <- participants_text |>
  translate_var_names()
 
participants_deidentified <- participants_text |>
  select(-c(user_type, user_id, nickname, custom_field, ip, referrer, suggestions)) |>
  select(-last_col()) |>
  select(-s_match("*fill"))

glimpse(participants_deidentified)

