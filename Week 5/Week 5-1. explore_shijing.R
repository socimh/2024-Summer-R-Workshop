# Goal: Clean the Shijing data
# Import: shijing.json
# Output: console output and plots

# ===========================================================
##################### prepare the data ######################
# ===========================================================
pacman::p_load(tidyverse, statart, showtext)
showtext_auto()
showtext_opts(dpi = 300)

# Load the data
# Downloaded from https://github.com/chinese-poetry/chinese-poetry/blob/master/%E8%AF%97%E7%BB%8F/shijing.json
file <- "C:/Users/socim/Downloads/shijing.json"
tb <- read_data(file)


# ===========================================================
##################### explore the data ######################
# ===========================================================

# Data cleaning
tb %>% tibble()
glimpse(tb)

# Reshape the data
tb <- tb %>%
  unnest_longer(content) %>%
  mutate(
    paragraph = row_number(),
    .by = "title"
  )

tb

tb <- tb %>%
  mutate(
    paragraph_length = str_length(content)
  )

# the distribution of paragraph_length
tb %>%
  summ(paragraph_length)
tb %>%
  s_plot(paragraph_length)

# paragraph_length is 10n (n is an integer)
# + - * / %% %/%
# a / b = c ...... d
9:11 %% 10 # %% is the modulo operator (remainder of division 余数)
tb %>%
  summ(paragraph_length %% 10 == 0)
tb %>%
  tab(paragraph_length %% 10 == 0)


# ===========================================================
################### regular expression  #####################
# ===========================================================

# Regular expression (regex, 正则表达式)

# Position
str_view(fruit, "a")
str_view(fruit, "^a") # ^: start of the string
str_view(fruit, "a$") # $: end of the string
str_view(fruit, "^apple$")

# Selection
str_view(fruit, "[aeiou]$") # [abc]: a, b, or c
str_view(fruit, "r[a-zA-Z]$") # [a-zA-Z]: one of the characters
str_view(fruit, "(a|e|i|o|u)$") # (a|b|c): a, b, or c
str_view(fruit, "(apple|pepper)$") # (apple|pepper): apple or pepper
str_view(fruit, "apple$|pepper$") # same as above

# Quantifiers
str_view(fruit, "p{2}")
str_view(fruit, "p{1,3}")
str_view(fruit, "pe")
str_view(fruit, "p+e") # +: 1 or more
str_view(fruit, "p*e") # *: 0 or more
str_view(fruit, "p?e") # ?: 0 or 1

# Metacharacters
# In R, there is no '\', but only '\\'
str_view(sentences, "\\w{10}") # \\w: word character
str_view(sentences, "\\w{10}\\s") # \\s: whitespace
str_view(sentences, "\\s\\w{10}\\s") # find the words with spaces around

telephones <- c(
  "123-456-7890",
  "123.456.7890",
  "123 456 7890",
  "1234567890",
  "1234567891",
  "1234567892"
)

str_view(telephones, "^\\d{10}") # \\d: digit
str_view(telephones, "^\\d{3}\\s?\\d{3}")
str_view(telephones, "^.{10}") # .: anything

str_view(fruit, "^a.*e$") # .*: 0 or more of anything

str_view(telephones, "^.*$") # .*: 0 or more of anything
str_view(telephones, "^.+$") # .+: 1 or more of anything

# Look around
str_view(sentences, "\\s\\w{10}\\s") # this includes the whitespaces

str_view(sentences, "(?<=\\s)\\w{10}\\s") # (?<=a): preceded by a
str_view(sentences, "\\s\\w{10}(?=\\s)") # (?=b): followed by b
str_view(sentences, "(?<=\\s)\\w{10}(?=\\s)") # only the words

str_view(sentences, "\\w{10}") # What's the difference?


# Wrapping up:
# How to find the 10-character words?
str_view(
  sentences,
  "(?<=\\s)\\w{10}(?=[\\s\\.\\?!])|^\\w{10}(?=\\s)"
)

# Explain:
# (?<=\\s)\\w{10}(?=[\\s\\.\\?!]):
#     preceded by a whitespace,
#     followed by a whitespace, period, question mark, or exclamation mark
# ^\\w{10}(?=\\s):
#     start of the string,
#     followed by a whitespace

# How to use this regex in R?
sentences %>%
  str_extract(
    "(?<=\\s)\\w{10}(?=[\\s\\.?!])|^\\w{10}(?=\\s)"
  ) %>%
  # remove NA elements
  discard(is.na)

# Another solution
sentences %>%
  str_split("\\s") %>%
  flatten() %>%
  str_c() %>% # all functions starting with str_...() come from stringr
  str_extract("\\w{10}") %>%
  discard(is.na)



# ===========================================================
################### character analysis ######################
# ===========================================================

############# String detection #############
# str_detect() returns a logical vector
tb %>%
  filter(content %>% str_detect("女"))

tb %>%
  tab(content %>% str_detect("女"))
tb %>%
  summ(content %>% str_detect("女"))
tb %>%
  summ(content %>% str_detect("我"), .by = chapter)
tb %>%
  summ(content %>% str_detect("君子"), .by = chapter)
tb %>%
  summ(content %>% str_detect("王"), .by = chapter)


############# String extraction #############
# str_extract() returns the matched part
tb %>%
  mutate(
    volumne = str_extract(chapter, "[大小]?\\w$")
  ) %>%
  tab(volumne)

tb <- tb %>%
  mutate(
    volumne = str_extract(chapter, "[大小]?\\w$") %>%
      fct_relevel("风", "小雅", "大雅", "颂")
  )

############# String analysis #############
tb %>%
  summ(paragraph_length, .by = volumne) %>%
  mutate(
    sum = n * mean,
    percent = sum / sum(sum)
  )

############# String visualization #############
tb %>%
  summ(paragraph_length, .by = volumne) %>%
  mutate(
    sum = n * mean,
    percent = sum / sum(sum)
  ) %>%
  ggplot() +
  geom_col(aes(volumne, sum), fill = "skyblue") +
  theme_bw()

# If I need a special tibble for multiple plotting and/or exporting
# I would create a new tibble called "plot_tb".
# As a good practice, "plot_tb" should be a tibble, whereas "tb_plot" may be a ggplot object.
plot_tb <- tb %>%
  summ(
    wo = content %>% str_detect("我"),
    junzi = content %>% str_detect("君子"),
    wang = content %>% str_detect("王"),
    .by = volumne
  ) %>%
  # to reorder the categories (optional)
  mutate(
    title = fct_relevel(
      name, "wo", "junzi", "wang"
    )
  )

plot_tb %>%
  ggplot() +
  aes(volumne, title, fill = mean) +
  # Better for many ordered categories
  # Not appropriate for this case
  geom_raster() +
  scale_fill_distiller(palette = "Blues", direction = 1) +
  theme_bw()

plot_tb %>%
  ggplot() +
  aes(volumne, mean, fill = title) +
  # Suitable for this case
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Blues", direction = 1) +
  theme_bw()

############# String manipulation #############
# str_replace() replaces the first matched part
tb %>%
  mutate(
    content = str_replace(content, "女", "男")
  ) %>%
  select(content)

# str_replace_all() replaces all matched part
tb %>%
  mutate(
    content = content %>% str_replace_all("。", "！")
  ) %>%
  select(content)

tb %>%
  mutate(
    content = content %>% str_replace_all("\\w{2}(?=。)", "____")
  ) %>%
  select(content)

############# String removal #############
# str_remove() and str_remove_all() remove the matched part
tb %>%
  mutate(
    content = content %>% str_remove("\\w{2}(?=。)")
  ) %>%
  select(content)

tb %>%
  mutate(
    content = content %>% str_remove_all("\\w{2}(?=。)")
  ) %>%
  select(content)

############# String joining #############
# Two ways of joining strings
tb %>%
  mutate(
    # section + `·` + title
    title = paste0(section, "·", title)
  )

# In Python, a + b is equivalent to paste0(a, b)

tb %>%
  mutate(
    # insert `section` and `title` into the string
    title = str_glue("{section}·{title}")
  )



# ===========================================================
#################### advanced analysis ######################
# ===========================================================
# "(\\w)\\1" means a word character followed by the same word character
# E.g., "关关", "萋萋". These are reduplications (叠词).
str_view(fruit, "\\w{2}") # any two characters
str_view(fruit, "(\\w)\\1")

tb <- tb %>%
  mutate(reduplication = content %>% str_count("(\\w)\\1"))

tb %>%
  summ(
    reduplication,
    .by = volumne,
    .stat = c("mean", "se")
  )

tb %>%
  filter(
    reduplication > 2 & volumne == "颂"
  ) %>%
  select(content)

tb %>%
  filter(
    reduplication > 2 & volumne == "小雅"
  ) %>%
  select(content)
