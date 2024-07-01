# Goal: Visualize the diamonds data
# Import: diamonds
# Output: plot.png

# ===========================================================
##################### prepare the data ######################
# ===========================================================

# Load the required packages and the data
pacman::p_load(
  tidyverse, statart
)

data(diamonds)

# ===========================================================
##################### quick visualization ###################
# ===========================================================

# continuous variable(s)
diamonds %>%
  summ()

diamonds %>%
  summ(carat)

# hist in Stata
diamonds %>%
  s_plot(carat)

diamonds %>%
  s_plot(price)

diamonds %>%
  slice_sample(n = 1000) %>% # too many diamonds in the dataset
  set_seed(20240624) %>%
  s_plot(carat, price)

# categorical variable(s)
diamonds %>%
  s_plot(cut)

diamonds %>%
  s_plot(clarity)

diamonds %>%
  s_plot(cut, clarity)

# a categorical variable + a continuous variable
diamonds %>%
  s_plot(cut, price)

diamonds %>%
  s_plot(cut, carat)

# a continuous variable + a categorical variable
# not recommended; not informative
diamonds %>%
  slice_sample(n = 1000) %>%
  set_seed(20240624) %>%
  s_plot(carat, cut)


# ===========================================================
################## basic grammar of ggplot #################
# ===========================================================

#################### ggplot() + aes() ####################
# ggplot() is the basic function to create a blank canvas
ggplot()

# Usually, we need to specify the data,
# ... but it does not change the blank canvas
ggplot(diamonds)

# aes() is used to specify the aesthetics (variables)
# Use `+` to add layers in ggplot, just like `%>%` piping in dplyr
ggplot(diamonds) +
  aes(carat)

ggplot(diamonds) +
  aes(carat, price)

ggplot(diamonds) +
  aes(cut)

ggplot(diamonds) +
  aes(cut, carat)

#################### geom_...() ####################
# geom_...() is used to add geometric objects (plots)
ggplot(diamonds) +
  aes(carat) +
  geom_histogram()

diamonds %>%
  slice_sample(n = 1000) %>%
  set_seed(20240624) %>%
  ggplot() +
  aes(carat, price) +
  geom_point()

# There should be only one ggplot() in a plot,
# but there can be multiple geom_...() in a plot
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin() +
  geom_boxplot()

# In fact, aes() can be also put in ggplot() or geom_...()
diamonds %>%
  ggplot(aes(cut, price)) +
  geom_violin() +
  geom_boxplot()

diamonds %>%
  ggplot() +
  geom_violin(aes(cut, price)) +
  geom_boxplot(aes(cut, price))

# ... and it is possible to add different aes() in different geom_...()
diamonds %>%
  mutate(price2 = price * 2) %>%
  ggplot() +
  geom_violin(aes(cut, price)) +
  geom_boxplot(aes(cut, price2, fill = cut))

# Nonetheless, beginners may start with the most straightforward way:
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin() +
  geom_boxplot()

# Of course, we could add some arguments to geom_...()
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(fill = "lightyellow") +
  geom_boxplot(width = .1, outliers = FALSE)

# If you want to give different fill colors to different groups,
# add it in aes()
diamonds %>%
  ggplot() +
  aes(cut, price, fill = cut) +
  geom_violin() +
  geom_boxplot(width = .1, outliers = FALSE)

# Sometimes, we only wanna add aes(fill = ...) in one geom_...()
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) + # put aes(fill = ...) here
  geom_boxplot(width = .1, outliers = FALSE)


#################### annotate() ####################

# Some components may not come from the data.
# Use annotate() to add text, points, or lines to the plot.
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  annotate(
    # Think about the most similar geom_...() to the component you want to add.
    # write the "..." here:
    "label", # -> geom_label()
    x = "Ideal",
    y = 1e4,
    fill = "gray80",
    label = "Ideal"
  )


#################### theme_...() ####################

# Use theme() to control the appearance of the plot.
# I prefer to use theme_bw(), theme_classic(), or theme_minimal().
# By default, ggplot2 uses theme_grey(), which is ugly.
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  theme_bw()

# Use labs() to add titles and labels to the plot.
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  theme_bw() +
  labs(
    # I seldom add a title to the plot, because it is usually redundant.
    # Yet, you can add a title if you want.
    # title = "Price by Cut",
    x = "Cut",
    y = "Price",
    fill = "",
    # Normally we do not need this. Just for fun.
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

#################### coord_...() ####################

# Use coord_...() to control the coordinate system (坐标系).
# coord_cartesian() does not change the plot, but it is useful to zoom in.
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  coord_cartesian(ylim = c(0, 1e4)) + # 1e4 = 10,000
  theme_bw() +
  labs(
    x = "Cut",
    y = "Price",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

# coord_flip() is used to flip the x and y axes.
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  coord_flip(ylim = c(0, 1e4)) +
  theme_bw() +
  labs(
    x = "Price",
    y = "Cut",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

#################### facet_...() ####################

# Use facet_...() to create facets (分面).
diamonds %>%
  mutate(
    carat3g = cut_quantile(carat, 3)
  ) %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  facet_wrap(~carat3g) +
  theme_bw() +
  labs(
    x = "Cut",
    y = "Price",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

#################### scale_...() ####################

# Use scale_...() to control the scales.
# alter the labels of the x-axis
diamonds %>%
  mutate(
    carat3g = cut_quantile(carat, 3)
  ) %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  scale_x_discrete(
    labels = c("Fair", "Good", "Very\nGood", "Premium", "Ideal")
  ) +
  facet_wrap(~carat3g) +
  theme_bw() +
  labs(
    x = "Cut",
    y = "Price",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

# alter the breaks and labels of the y-axis
diamonds %>%
  mutate(
    carat3g = cut_quantile(carat, 3)
  ) %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  scale_x_discrete(
    labels = c("Fair", "Good", "Very\nGood", "Premium", "Ideal")
  ) +
  scale_y_continuous(
    # seq(start, end, step)
    breaks = seq(0, 18e3, 3e3), # 18e3 = 18,000
    labels = scales::dollar_format()
  ) +
  facet_wrap(~carat3g) +
  theme_bw() +
  labs(
    x = "Cut",
    y = "Price",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

# alter the fill colors
diamonds %>%
  mutate(
    carat3g = cut_quantile(carat, 3)
  ) %>%
  ggplot() +
  aes(cut, price) +
  geom_violin(aes(fill = cut)) +
  geom_boxplot(width = .1, outliers = FALSE) +
  scale_x_discrete(
    labels = c("Fair", "Good", "Very\nGood", "Premium", "Ideal")
  ) +
  scale_y_continuous(
    # seq(start, end, step)
    breaks = seq(0, 18e3, 3e3), # 18e3 = 18,000
    labels = scales::dollar_format()
  ) +
  scale_fill_brewer(
    palette = "YlOrRd",
    # Remove the legend by setting guide = "none"
    # This is AWFULLY difficult to remember!!!
    # However, I still recommend you to use it instead of other alternatives.
    guide = "none"
  ) +
  facet_wrap(~carat3g) +
  theme_bw() +
  labs(
    x = "Cut",
    y = "Price",
    fill = "",
    caption = str_glue("Created on {Sys.time()}") %>%
      str_remove("\\.\\d+$")
  )

#################### summary ####################
# The basic grammar of ggplot is:
# ggplot(data) +
#   aes(...) +
#   geom_part +
#   annotate() +
#   scale_part +
#   coord_part +
#   facet_part +
#   theme_...() +
#   labs()
#
# Where each "part" consists of many functions.
# Also, the order of most parts can be changed.

# However, only the first three parts are compulsory:
# ggplot(data) +
#   aes(...) +
#   geom_part
#
# Remember this plot?
diamonds %>%
  ggplot() +
  aes(cut, price) +
  geom_violin() +
  geom_boxplot()

# What are the available functions?
# See https://ggplot2.tidyverse.org/reference/index.html#aesthetics.
# Skip useless or complicated functions (e.g., position_dodge() or guide_axis())
# that we have not discussed yet.


# ===========================================================
################# dplyr/statart + ggplot2 ###################
# ===========================================================

# max price by cut
diamonds %>%
  summ(price, .by = cut) %>%
  ggplot() +
  aes(cut, max) +
  geom_col(
    fill = "gray", # fill color
    color = "black", # border color
  ) +
  theme_bw()

# mean price by cut and color
diamonds %>%
  summ(price, .by = cut:color) %>%
  ggplot() +
  aes(cut, color, fill = mean) +
  geom_raster() +
  scale_fill_viridis_c() +
  theme_bw()

# frequency of cut-color combinations
diamonds %>%
  mutate(
    carat100g = cut_length(carat, 100),
    price100g = cut_length(price, 100)
  ) %>%
  s_plot(carat100g, price100g) +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

# the relationship between carat, depth, and price (continuous)
diamonds %>%
  mutate(
    carat100g = cut_length(carat, 100),
    depth100g = cut_length(depth, 100)
  ) %>%
  summ(price, .by = carat100g:depth100g) %>%
  ggplot() +
  aes(carat100g, depth100g, fill = mean) +
  geom_raster() +
  scale_fill_viridis_c() +
  theme_bw() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

# the relationship between carat, depth, and price (discrete)
diamonds %>%
  mutate(
    carat100g = cut_length(carat, 100),
    depth100g = cut_length(depth, 100)
  ) %>%
  summ(price, .by = carat100g:depth100g) %>%
  mutate(price5g = cut_quantile(mean, 5)) %>%
  ggplot() +
  aes(carat100g, depth100g, fill = price5g) +
  geom_raster() +
  scale_fill_viridis_d() +
  theme_bw() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )
