# Goal: Clean the half-marathon data
# Import: 汉马逐公里数据.xlsx
# Output: plot.png

# ===========================================================
##################### prepare the data ######################
# ===========================================================

# Load the required packages and the data
pacman::p_load(
  tidyverse, statart, showtext
)

# If you want to insert Chinese characters, load 'showtext';
# otherwise, do not load it.
showtext_auto()
showtext_opts(dpi = 300)

run <- readxl::read_excel(
  "D:/R/Teaching/2024 Summer R Workshop/Week 4/汉马逐公里数据.xlsx",
) %>%
  # clean some variables
  mutate(
    distance = parse_number(distance),
    segment = distance - lag(distance, default = 0),
    pace = str_remove(pace, "min/km") %>% ms(),
    elevation_up = str_extract(elevation, "(?<=\\+)\\d+") %>%
      parse_number(),
    elevation_down = str_extract(elevation, "(?<=\\-)\\d+") %>%
      parse_number(),
    elevation = NULL,
    power = parse_number(power),
    elevation = elevation_up - elevation_down,
    speed = 1000 / as_numeric(pace)
  )


# ===========================================================
################# quickly summarize and plot ################
# ===========================================================

run %>%
  summ()

run %>%
  s_plot(distance, heart_rate)

run %>%
  s_plot(speed, power)

run %>%
  filter(heart_rate > 150) %>%
  s_plot(heart_rate, speed)

run %>%
  mutate(
    stride_length = parse_number(stride_length)
  ) %>%
  s_plot(stride_length, speed) +
  labs(y = "速度 (m/s)")


# ===========================================================
######################## speed trend #######################
# ===========================================================

gg <- run %>%
  mutate(
    elevation = elevation_up - elevation_down
  ) %>%
  ggplot() +
  aes(distance, speed) +
  geom_line(lwd = .5) +
  geom_point(aes(fill = elevation, size = segment), shape = 21) +
  geom_hline(
    yintercept = 3.98, color = "firebrick",
    lwd = 1, linetype = "dashed") +
  scale_x_continuous(
    labels = scales::label_number(suffix = " 公里")
  ) +
  scale_fill_viridis_c(
    "海拔变化",
    direction = -1
  ) +
  scale_size_continuous(
    range = c(1, 4),
    guide = "none"
  ) +
  labs(
    x = "距离",
    y = "每公里配速"
  ) +
  theme_bw() +
  theme(axis.text.y = element_text(
    colour = c(rep("black", 6), "firebrick")
  ))

gg
path <- "D:/R/Teaching/2024 Summer R Workshop/Week 4/plot.png"
ggsave(path, gg, width = 5, height = 3.2)


# ===========================================================
######################## pace trend #########################
# ===========================================================

avg_pace <- run %>% summ(as.numeric(pace)) %>% pull(mean)
pace_breaks <- seq(240, 270, 5) %>% c(avg_pace)
number_to_pace <- function(number) {
  min <- number %/% 60
  sec <- number %% 60
  sec_pad <- sec %>%
    round() %>%
    str_pad(2, pad = "0")
  str_glue("{min}'{sec_pad}''") %>%
    return()
}

gg <- run %>%
  filter(distance <= 21) %>%
  ggplot() +
  aes(distance, pace) +
  geom_line(lwd = .5) +
  geom_point(aes(fill = as.numeric(pace)), shape = 21, size = 3) +
  geom_hline(yintercept = avg_pace, color = "firebrick", lwd = 1, linetype = "dashed") +
  annotate(
    "label",
    x = 3, y = 268.3, label = "更慢", fill = "#FFFFB2"
  ) +
  annotate(
    "label",
    x = 20, y = 245, label = "更快", fill = "#B10026", color = "white"
  ) +
  scale_y_continuous(
    breaks = pace_breaks,
    labels = number_to_pace(pace_breaks)
  ) +
  scale_x_continuous(
    labels = scales::label_number(suffix = " 公里")
  ) +
  scale_fill_distiller(
    palette = "YlOrRd",
    guide = "none"
  ) +
  labs(
    x = "距离",
    y = "每公里配速"
  ) +
  theme_bw() +
  theme(axis.text.y = element_text(
    colour = c(rep("black", 6), "firebrick")
  ))

# I prefer to save all plots with the same name.
# In other words, the last plot will overwrite the previous one.
# This keeps the folder clean.
# The previous plot can be pasted into a Word document or a PowerPoint slide.

# If you want to keep all plots, you can change the path.
ggsave(path, gg, width = 4.5, height = 3.2)

