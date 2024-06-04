1
a <- 1

a

a <- "你好，R!"

pacman::p_load(tidyverse, statart)

s_type(a)
s_type(b)
s_type(123) # double means real number (实数，小数) in R
s_type(123L) # integer means 整数 in R

s_type(TRUE) # TRUE means 真 in R
s_type(FALSE) # FALSE means 假 in R
s_type(NA) # NA means not available in R (missing)

s_type("你好，R!") # character means 字符串 in R
s_type("123") # character means 字符串 in R

s_type(s_type) # s_type() means function (函数) in R
# 一般都是 function() 的形式出现


df <- data.frame(
  a = 1:25,
  b = letters[1:25]
)

tb <- as_tibble(df)
tb

tab(tb)

diamonds
diamonds %>% print_headtail()
diamonds %>% print_headtail(20)
diamonds %>% print_interval()
diamonds %>% print_interval(20)

diamonds %>% print_interval()
print_interval(diamonds) # Equivalent to the above

glimpse(diamonds)


view(diamonds)
browse(diamonds, x:z) # br x-z in Stata


library(flextable)
as_flextable(diamonds, max_row = 20)

as_flextable(diamonds, max_row = 20) %>%
  save_as_docx(path = "diamonds.docx")


library(pillar) # for printing tibbles

# 时间复杂度（tidyverse 比较慢）
# 空间复杂度（tidyverse 比较占内存）
# 代码复杂度（tidyverse 一点也不复杂）

print(tb, n = 5)

lifeexp
tab(lifeexp, region)

# How to use "global" in R:
data_folder <- "path_to_folder"

file.path(data_folder, "abc.dta") # 自动加上 /
paste0(data_folder, "/abc.dta") # 两个字符简单相连
str_glue("{data_folder}/abc.dta") # 用 {} 括起来


