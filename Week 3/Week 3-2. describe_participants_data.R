# Goal:
#       1. Describe the participants data
#       2. Showcase how to use many dplyr functions simultaneously
#
# Import: participants_deidentified.csv
# Previous R scripts:
#       -  A1. preclean_participants_data.R
#       -  A2. translate_var_names.R
#
# Output: tmp.png and console output

# Load the required packages and the data
pacman::p_load(tidyverse, statart)

path <- "D:/R/Teaching/2024 Summer R Workshop/Week 3/participants_deidentified.csv"
tb <- read_data(path)


# ===========================================================
##################### Unavailable weekdays ##################
# ===========================================================

tb %>%
  select(id, s_match("unavailable*")) %>%
  select(-2) %>%
  pivot_longer(
    cols = -id,
    names_to = "day",
    values_to = "unavailable"
  ) %>%
  mutate(
    ndays = is.na(unavailable) %>% sum(),
    .by = id
  ) %>%
  filter(ndays >= 3) %>%
  tab(unavailable)



# ===========================================================
##################### Educational background ################
# ===========================================================

tb %>%
  tab1(school, stage)

tb %>%
  tab(school, stage)



# ===========================================================
################### Desired topics to learn ################
# ===========================================================

# sort the desired topics to learn
tb %>%
  select(id, s_match("learn_r*")) %>%
  select(-last_col()) %>%
  pivot_longer(
    cols = -c(1:2),
    names_to = "topic_eng",
    values_to = "topic_chn"
  ) %>%
  mutate(
    mention_all = !is.na(learn_r_all),
    mention = !is.na(topic_chn),
    topic_eng = str_remove(topic_eng, "learn_r_"),
    topic_chn = str_remove(topic_chn, "^\\w\\.")
  ) %>%
  group_by(topic_eng) %>%
  fill(topic_chn, .direction = "updown") %>%
  ungroup() %>%
  mutate(
    mention_n = mention_all + mention
  ) %>%
  summ(mention_n, .by = c(topic_eng, topic_chn)) %>%
  arrange(-mean)


# ===========================================================
##################### Software background ##################
# ===========================================================

tb %>%
  tab(
    stata = !is.na(software_stata),
    r = !is.na(software_r)
  )

# Tabulate the software usage
tb %>%
  pivot_longer(
    cols = matches("^software_"),
    names_to = "software",
    values_to = "command"
  ) %>%
  select(id, school, software, command) %>%
  mutate(
    software = str_remove(software, "^software_"),
    command = str_remove_all(command, "^\\w\\.")
  ) %>%
  filter(!is.na(command)) %>%
  tab(command)


# Visualize the software usage
gg <- tb %>%
  mutate(
    across(
      matches("^software_"),
      ~ !is.na(.)
    )
  ) %>%
  summ(matches("^software_")) %>%
  select(name, mean) %>%
  mutate(
    order = row_number(),
    name = str_remove(name, "^software_"),
    name = case_when(
      name %in% c("spss", "gis") ~ str_to_upper(name),
      name == "cpp" ~ "C++",
      name == "javascript" ~ "JavaScript",
      TRUE ~ str_to_title(name)
    ),
    name = fct_reorder(name, order)
  ) %>%
  filter(mean > 0) %>%
  ggplot() +
  aes(name, mean) +
  geom_col(
    width = .6,
    color = "black",
    fill = "gray"
  ) +
  geom_text(
    aes(label = scales::percent(mean, accuracy = 1)),
    vjust = -0.75,
    size = 4
  ) +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_bw() +
  labs(
    x = "Software",
    y = "Proportion",
    subtitle = "Proportion of participants who use each software"
  )

gg # display the plot

# saved in the destination folder
out_path <- "D:/R/Teaching/2024 Summer R Workshop/Week 3/tmp.png"
ggsave(out_path, gg, width = 6, height = 4, units = "in")
