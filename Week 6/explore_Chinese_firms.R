pacman::p_load(tidyverse, statart)

# Load the data
# Downloaded from https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/TPR4VU/VQVTQQ&version=3.0
# Wang, Yuhua, 2020, "2011.xlsx", Chinese Listed Firms Personnel Database, https://doi.org/10.7910/DVN/TPR4VU/VQVTQQ, Harvard Dataverse, V3
# Wang, Yuhua, 2020, "Chinese Listed Firms Personnel Database", https://doi.org/10.7910/DVN/TPR4VU, Harvard Dataverse, V3, UNF:6:WkXSf3F2h0PA4/fYOUpepA== [fileUNF]
file <- "C:/Users/socim/Downloads/Chinese_firms_2011.xlsx"
tb2011 <- read_data(file)

# Data cleaning
glimpse(tb2011)

tb2011 %>%
  tab(starts_with("..."))

tb2011 <- tb2011 %>%
  select(-starts_with("...")) %>%
  glimpse()

tb2011 %>%
  arrange(任职日期) %>%
  print_interval(20)

tb2011 %>%
  mutate(
    digits = log10(任职日期) %>% ceiling()
  ) %>%
  tab(digits, .desc = TRUE)

tb2011 %>%
  mutate(
    digits = log10(任职日期) %>% ceiling()
  ) %>%
  filter(digits == 6)

tb2011 %>%
  mutate(
    appoint_date = as.character(任职日期),
    appoint_date = case_when(
      str_length(appoint_date) == 4 ~ str_glue("{appoint_date}0701"),
      str_length(appoint_date) == 6 ~ str_glue("{appoint_date}15"),
      TRUE ~ appoint_date
    )
  ) %>%
  relocate(任职日期, appoint_date)

tb2011 <- tb2011 %>%
  mutate(
    appoint_date = as.character(任职日期),
    appoint_date = case_when(
      str_length(appoint_date) == 4 ~ str_glue("{appoint_date}0701"),
      str_length(appoint_date) == 6 ~ str_glue("{appoint_date}15"),
      TRUE ~ appoint_date
    ),
    appoint_date = as.Date(appoint_date, format = "%Y%m%d"),
    announce_date_wrong = as.Date(公告日期, format = "%Y%m%d"),
    announce_date = 公告日期 %>%
      as.character() %>%
      as.Date(format = "%Y%m%d"),
    resign_date = 离职日期 %>%
      as.character() %>%
      as.Date(format = "%Y%m%d"),
    country = 国际,
    chinese = str_detect(country, "中国") %>%
      value_if_na(FALSE)
  )

tb2011 %>%
  slice(9) %>%
  pull(姓名)

tb2011 %>%
  tab(country) %>%
  print(n = Inf)

# Calculate the trend of foreign executives
tb2011 %>%
  mutate(
    foreign = 1 - chinese
  ) %>%
  ggplot() +
  aes(appoint_date, foreign) +
  geom_smooth() +
  coord_cartesian(ylim = c(0, .016)) +
  scale_y_continuous(labels = scales::percent_format())

tb2011 %>%
  mutate(
    appoint_ym = floor_date(appoint_date, "month") + 14
  ) %>%
  summ(1 - chinese, .by = appoint_ym) %>%
  ggplot() +
  aes(appoint_ym, mean) +
  geom_point() +
  geom_smooth() +
  coord_cartesian(ylim = c(0, .016)) +
  scale_y_continuous(labels = scales::percent_format())

tb2011 %>%
  mutate(
    # Group the date by year
    appoint_year = floor_date(appoint_date, "year") + 181
  ) %>%
  summ(1 - chinese, .by = appoint_year) %>%
  ggplot() +
  aes(appoint_year, mean) +
  geom_line(color = "gray30") +
  geom_smooth(se = FALSE) +
  coord_cartesian(ylim = c(0, .016)) +
  scale_y_continuous(labels = scales::percent_format())

tb2011 %>%
  mutate(
    # Directly extract the year (as a number)
    appoint_year = year(appoint_date)
  ) %>%
  summ(1 - chinese, .by = appoint_year) %>%
  ggplot() +
  aes(appoint_year, mean) +
  geom_line(color = "gray30") +
  geom_smooth(se = FALSE) +
  coord_cartesian(ylim = c(0, .016)) +
  scale_y_continuous(labels = scales::percent_format())




tb2011 %>%
  mutate(
    appoint_year = year(appoint_date)
  ) %>%
  summ(性别 == "女", .by = appoint_year) %>%
  ggplot() +
  aes(appoint_year, mean) +
  geom_line(color = "gray30") +
  geom_smooth() +
  scale_y_continuous(labels = scales::percent_format())

tb2011 %>%
  tab(出生年份) %>%
  print_interval()

tb2011 %>%
  mutate(
    appoint_year = year(appoint_date),
    year_of_birth = as.character(出生年份) %>%
      str_extract("^\\d{4}") %>%
      as.numeric(),
    age = appoint_year - year_of_birth
  ) %>%
  summ(age, .by = appoint_year) %>%
  ggplot() +
  aes(appoint_year, mean) +
  geom_line(color = "gray30") +
  geom_smooth()

tb2011 %>%
  mutate(
    appoint_year = year(appoint_date),
    year_of_birth = as.character(出生年份) %>%
      str_extract("^\\d{4}") %>%
      as.numeric(),
    age = appoint_year - year_of_birth,
    appoint_ym = floor_date(appoint_date, "month") + 14
  ) %>%
  summ(age, .by = appoint_ym) %>%
  ggplot() +
  aes(appoint_ym, mean) +
  geom_point() +
  geom_smooth() +
  statart:::theme_statart()



tb2011 %>%
  tab(学历)

tb2011 %>%
  s_plot(学历)

tb2011 %>%
  mutate(
    edu7g = case_when(
      str_detect(学历, "小学") ~ 1,
      str_detect(学历, "初中") ~ 2,
      str_detect(学历, "高中|中职") ~ 3,
      str_detect(学历, "专科") ~ 4,
      str_detect(学历, "本科") ~ 5,
      str_detect(学历, "硕士") ~ 6,
      str_detect(学历, "博士") ~ 7
    )
  ) %>%
  tab(edu7g)

demo_tb <- tb2011 %>%
  mutate(
    edu7g = case_when(
      str_detect(学历, "小学") ~ 1,
      str_detect(学历, "初中") ~ 2,
      str_detect(学历, "高中|中职") ~ 3,
      str_detect(学历, "专科") ~ 4,
      str_detect(学历, "本科") ~ 5,
      str_detect(学历, "硕士") ~ 6,
      str_detect(学历, "博士") ~ 9
    ) %>%
      factor(
        labels = c(
          "小学",
          "初中",
          "高中",
          "大专",
          "本科",
          "硕士",
          "博士"
        )
      )
  ) %>%
  tab(edu7g)

demo_tb

demo_tb %>%
  mutate(
    edu_num = as_numeric(edu7g),
    edu_chr = as_character(edu7g)
  ) %>%
  relocate(starts_with("edu"))

demo_tb %>%
  mutate(
    edu7g = fct_reorder(edu7g, n)
  ) %>%
  arrange(edu7g)

demo_tb %>%
  mutate(
    edu7g = fct_rev(edu7g)
  ) %>%
  arrange(edu7g)

demo_tb %>%
  mutate(
    edu7g = edu7g %>%
      fct_relabel(
        ~ str_replace(., "高中", "高中/中职")
      )
  ) %>%
  arrange(edu7g)

demo_tb %>%
  mutate(
    edu7g = edu7g %>%
      as_character() %>%
      str_replace("高中", "高中/中职") %>%
      factor(
        levels = c(
          "小学",
          "初中",
          "高中/中职",
          "大专",
          "本科",
          "硕士",
          "博士"
        )
      )
  ) %>%
  arrange(edu7g)

tb2011 %>%
  tab(str_extract(交易代码, "\\w{2}$"))


# Factors are similar to categorical variables.
# The only reason to convert characters to factors ...
# ... is to specify the order of the levels!

tb2011 %>%
  slice_sample(n = 10) %>%
  set_seed(20240625) %>%
  mutate(
    id = factor(ID)
  ) %>%
  s_plot(id)

# Converting numbers to factors can be useful for grouping.
