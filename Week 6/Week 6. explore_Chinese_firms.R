# Goal: Clean the Chinese Firms data
# Import: Chinese_firms_2011.xlsx
# Output: console output and plots

# ===========================================================
##################### prepare the data ######################
# ===========================================================
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
  # take a look at the redundant columns
  tab(starts_with("...")) %>%
  select(n:valid_cum)

tb2011 <- tb2011 %>%
  # safely remove them
  select(-starts_with("..."))

tb2011 %>%
  glimpse()


# ===========================================================
################ manipulate date variables ##################
# ===========================================================
tb2011 %>%
  arrange(任职日期) %>%
  print_interval(20)

c(999, 4500, 9999) %>%
  log10() %>%
  ceiling()

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

# Two ways of generating date variables
# 1. From numeric:
as.Date(0) # "1970-01-01"
as.Date(1) # "1970-01-02"
as.Date(365) # "1971-01-01"
as.Date(1, origin = "1960-01-01") # "1960-01-02"

# 2. From character:
as.Date("1970-01-01") # "1970-01-01"
as.Date("19700101") # wrong
as.Date("19700101", format = "%Y%m%d")


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
  select(公告日期, announce_date, announce_date_wrong)

tb2011 %>%
  select(国际, country, chinese)



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

pi
ceiling(pi)
floor(pi)

floor_date(as.Date(30), "month")
floor_date(as.Date(31), "month")
floor_date(as.Date(31), "year")

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

library(lubridate)

# year() extracts the year from a date
# month() extracts the month from a date
# day() extracts the day from a date
# wday() extracts the day of the week from a date
# quarter() extracts the quarter from a date
# ...

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



# ===========================================================
############## manipulate factor variables #################
# ===========================================================

tb2011 %>%
  tab(学历)

tb2011 %>%
  s_plot(学历)

library(showtext)
showtext_auto()

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

demo_tb %>%
  ggplot() +
  aes(edu7g, percent) +
  # Avoid using geom_bar() for factors
  geom_col()

demo_tb %>%
  s_plot(edu7g, n)


demo_tb %>%
  mutate(
    edu_num = as_numeric(edu7g),
    edu_chr = as_character(edu7g)
  ) %>%
  relocate(starts_with("edu"))

# fct_...() functions are used to manipulate factors
# Most of them reorders the levels of factors

demo_tb %>%
  mutate(
    edu7g = fct_reorder(edu7g, n)
  ) %>%
  arrange(edu7g)

demo_tb %>%
  mutate(
    edu7g = fct_reorder(edu7g, n)
  ) %>%
  s_plot(edu7g, n)



demo_tb %>%
  mutate(
    edu7g = fct_rev(edu7g)
  ) %>%
  arrange(edu7g)


demo_tb %>%
  mutate(
    edu7g = fct_rev(edu7g)
  ) %>%
  s_plot(edu7g, n)


demo_tb %>%
  mutate(
    edu7g = edu7g %>%
      fct_relabel(
        ~ str_replace(., "高中", "高中/中职")
      )
  ) %>%
  arrange(edu7g)

1:2 %>% factor(labels = c("a", "b"))
c("A", "B") %>% factor(labels = c("a", "b"))

# The same as above
# But much more complicated.
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

# Converting numbers to factors can be useful for grouping.
tb2011 %>%
  slice_sample(n = 10) %>%
  set_seed(20240625) %>%
  s_plot(ID)

tb2011 %>%
  slice_sample(n = 10) %>%
  set_seed(20240625) %>%
  mutate(
    id = factor(ID)
  ) %>%
  s_plot(id)

# These two lines are equivalent:
# reg y i.x
# lm(y ~ factor(x), tb)

tb2011 %>%
  mutate(
    gender = case_when(
      性别 == "女" ~ 1,
      性别 == "男" ~ 2
    ),
    gender_fct = factor(gender, labels = c("女", "男")),
    female = gender == 1
    ) %>%
  tab(性别, gender, gender_fct, female)


tb2011 <- tb2011 %>%
  mutate(
    gender = case_when(
      性别 == "女" ~ 1,
      性别 == "男" ~ 2
    ),
    female = gender == 1
  )



# ===========================================================
################ Clean model results ##################
# ===========================================================

# lm()
# glm()
# lmer()

fit <- glm(female ~ appoint_date, tb2011, family = "binomial")

fit %>% summary()

library(broom)
fit %>%
  tidy() %>%
  slice(2, 1)

fit %>%
  tidy_coef() %>%
  slice(2, 1) %>%
  select(1, 2)

fit %>%
  glance() %>%
  print(width = Inf)

fit %>%
  augment()


