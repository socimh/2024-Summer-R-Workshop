# Goal: Clean the metro pay methods data
# Import: metro-pay-methods.xlsx
# Output: console output and plots

# ===========================================================
##################### prepare the data ######################
# ===========================================================
pacman::p_load(tidyverse, statart, showtext)
showtext_auto()
showtext_opts(dpi = 300)

# Load the data
# Downloaded from https://github.com/Ivysauro/CNRT/blob/master/data/Pay.md
file <- "C:/Users/socim/Downloads/metro-pay-methods.xlsx"
tb <- read_data(file)

tb <- tb %>%
  rename_with(
    ~ c(
      "city", "since", "t_union", "union_pay_nfc", "alipay", "wechat_pay",
      "union_pay_app", "credit_card", "apps", "other"
    )
  ) %>%
  filter(!is.na(city))


# ===========================================================
##################### clean the data ######################
# ===========================================================
tb <- tb %>%
  mutate(
    across(
      c(t_union:apps),
      ~ str_detect(., "✅") %>%
        value_if_na(FALSE)
    ),
    city_code = str_extract(city, "^\\d+"),
    city_name = str_extract(city, "\\w+(?=/)"),
    city_pinyin = str_extract(city, "(?<=/\\s).+$")
  ) %>%
  relocate(s_match("city_*")) %>%
  select(-c(city, credit_card, other))


# ===========================================================
##################### analyze the data ######################
# ===========================================================
tb %>%
  summ()

tb %>%
  s_plot(since)

tb %>%
  filter(!t_union)

tb %>%
  tab2(alipay, wechat_pay)
tb %>%
  filter(alipay & !wechat_pay)
tb %>%
  filter(!alipay & wechat_pay)
