# Goal: Showcase how to get grouped summary statistics
# Import: diamonds
# Output: Console output

# ===========================================================
##################### prepare the data ######################
# ===========================================================

# Load the required packages and the data
pacman::p_load(
  tidyverse, statart
)

data(diamonds)
?diamonds

# ===========================================================
##################### one-variable summary ##################
# ===========================================================

# continuous variable(s)
diamonds %>%
  summ()

diamonds %>%
  select(where(is.numeric))

diamonds %>%
  summ(where(is.numeric))


# categorical variable(s)
diamonds %>%
  select(where(~ !is.numeric(.)))

diamonds %>%
  tab1(where(~ !is.numeric(.)))

diamonds %>%
  fre1(where(~ !is.numeric(.)))


# ===========================================================
######################## grouped summ() #####################
# ===========================================================

############## group_by() ##############

# group_by() changes the data structure
diamonds %>%
  class() # it is a tibble

diamonds %>%
  group_by(cut) %>%
  class() # it is a grouped_df (a subclass of tibble)

# group_by() %>% summ() is a common combination
diamonds %>%
  group_by(cut) %>%
  summ(price)

# summ(`tidyselect`) is acceptable.
diamonds %>%
  group_by(cut) %>%
  summ(x:z) %>%
  print(n = Inf)


############## .by ##############

# .by is a shortcut for group_by() %>% summ()

# It has three main advantages:
# 1. Easy to write.
# 2. Does not change the data structure.
# 3. No need to switch between group_by() and ungroup().

# Normally, we need to ungroup() after group_by()
diamonds %>%
  group_by(cut) %>%
  mutate(
    cut_avg_price = mean(price, na.rm = TRUE)
  ) %>%
  ungroup()

# This is more concise:
diamonds %>%
  mutate(
    cut_avg_price = mean(price, na.rm = TRUE),
    .by = cut
  )


# Not identical (different data structure)
identical(
  diamonds,
  diamonds %>% group_by(cut)
)

# Identical (the same data structure)
identical(
  diamonds,
  diamonds %>%
    group_by(cut) %>%
    ungroup()
)


# Hence, I recommend using .by
# summ(`tidyselect`, .by = `tidyselect`)
diamonds %>%
  summ(price, .by = cut)

diamonds %>%
  summ(price, .by = c(cut, clarity)) %>%
  print(n = Inf)

diamonds %>%
  summ(x:z, .by = cut) %>%
  print(n = Inf)

diamonds %>%
  summ(x:z, .by = c(cut, clarity)) %>%
  print(n = Inf)


# arrange() by variable names
diamonds %>%
  summ(x:z, .by = cut) %>%
  arrange(name) %>%
  print(n = Inf)

# We can even summ(.by) everything!
diamonds %>%
  summ(.by = cut) %>%
  arrange(name) %>%
  print(n = Inf)

# the same as above by using group_by()
diamonds %>%
  group_by(cut) %>%
  summ() %>%
  arrange(name) %>%
  print(n = Inf)

# the same as above by using everything()
diamonds %>%
  summ(everything(), .by = cut) %>%
  arrange(name) %>%
  print(n = Inf)

# arrange() by the original order
# Complicated. Just for demonstration.
diamonds %>%
  group_by(cut) %>%
  summ() %>%
  mutate(
    var_id = 1:n() %% 9,
    var_id = ifelse(
      var_id == 0, 9, var_id
    )
  ) %>%
  arrange(var_id) %>%
  select(-var_id) %>%
  print(n = Inf)



# ===========================================================
######################## grouped tab() ######################
# ===========================================================

# We can include two variables in tab()
diamonds %>%
  tab(cut, color)

# What is the difference?
diamonds %>%
  tab(color, .by = cut)

# What is the difference?
diamonds %>%
  tab(cut, .by = color)

# We can even include many variables before or after .by
diamonds %>%
  tab(color, clarity, .by = cut)

diamonds %>%
  tab(clarity, .by = c(cut, color))

# tidyselect
select()
ds()
across() # in mutate()
pivot_longer()
pivot_wider()

# data-masking
mutate()
rename()
transmute() # nearly 淘汰掉
summarsie()
reframe()
count()

# both tidyselect and data-masking
s_select()
tab()
fre()
summ()

# Even more, we can tab() an expression!
diamonds %>%
  tab(high_price = price >= 4e3, .by = c(cut, color)) %>%
  print(n = Inf)

diamonds %>%
  tab(high_price = price >= 4e3, .by = c(cut, color)) %>%
  filter(high_price) %>%
  print(n = Inf)

# What is the difference?
diamonds %>%
  summ(high_price = price >= 4e3, .by = c(cut, color)) %>%
  print(n = Inf)
