# Goal: Describe the participants data
# Import: participants_deidentified.csv
# Output: tmp.png and console output

# Load the required packages and the data
pacman::p_load(tidyverse, statart)

tb <- getwd() %>%
  file.path("Workshop Surveys Analysis", "participants_deidentified.csv") %>%
  read_data()


# Unavailable weekdays
tb |>
  select(id, s_match("unavailable*")) |>
  select(-2) |>
  pivot_longer(
    cols = -id,
    names_to = "day",
    values_to = "unavailable"
  ) |>
  mutate(
    ndays = sum(is.na(unavailable)),
    .by = id
  ) |>
  filter(ndays >= 3) |>
  tab(unavailable)

# Educational background
tb |>
  tab1(school, stage)

tb |>
  tab(school, stage)

# Software background
tb |>
  select(id, s_match("learn_r*")) |>
  select(-last_col()) |>
  pivot_longer(
    cols = -c(1:2),
    names_to = "topic_eng",
    values_to = "topic_chn"
  ) |>
  mutate(
    mention_all = !is.na(learn_r_all),
    mention = !is.na(topic_chn),
    topic_eng = str_remove(topic_eng, "learn_r_"),
    topic_chn = str_remove(topic_chn, "^\\w\\.")
  ) |>
  group_by(topic_eng) |>
  fill(topic_chn, .direction = "updown") |>
  ungroup() |>
  mutate(
    mention_n = mention_all + mention
  ) |>
  group_by(topic_eng, topic_chn) |>
  summ(mention_n) |>
  arrange(-mean)

participants_text |>
  tab(
    stata = !is.na(software_stata),
    r = !is.na(software_r)
  )

# Tabulate the software usage
participants_text |>
  pivot_longer(
    cols = matches("^software_"),
    names_to = "software",
    values_to = "command"
  ) |>
  select(id, school, software, command) |>
  mutate(
    software = str_remove(software, "^software_"),
    command = str_remove_all(command, "^\\w\\.")
  ) |>
  filter(!is.na(command)) |>
  tab(command)


# Visualize the software usage
gg <- participants_text |>
  mutate(
    across(
      matches("^software_"),
      ~ !is.na(.)
    )
  ) |>
  summ(matches("^software_")) |>
  select(name, mean) |>
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
  ) |>
  filter(mean > 0) |>
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

# saved in the working directory
ggsave("tmp.png", gg, width = 6, height = 4, units = "in")
