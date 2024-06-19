pacman::p_load(
  ggthemes, ggtext, 
  tidyverse, statart, showtext
)
showtext_auto()
showtext_opts(dpi = 300)

run <- readxl::read_excel(
  "D:/R/Running/汉马逐公里数据.xlsx",
) %>%
  mutate(
    distance = parse_number(distance), 
    pace = str_remove(pace, "min/km") %>% ms(), 
    elevation_up = str_extract(elevation, "(?<=\\+)\\d+") %>% 
      parse_number(),
    elevation_down = str_extract(elevation, "(?<=\\-)\\d+") %>% 
      parse_number(), 
    elevation = NULL, 
    power = parse_number(power)
  )

number_to_pace <- function(number) {
  min <- number %/% 60
  sec <- number %% 60
  sec_pad <- sec %>% str_pad(2, pad = '0')
  str_glue("{min}'{sec_pad}''") %>%
    return()
}


run %>% filter(elevation_up >= 5)
pace_breaks = seq(240, 270, 5) %>% c(252)
gg <- run %>%
  ggplot() +
  aes(distance, pace) +
  geom_line(lwd = .5) +
  geom_point(aes(fill = as.numeric(pace)), shape = 21, size = 3) +
  geom_hline(yintercept = 252, color = "firebrick", lwd = 1, linetype = "dashed") +
  annotate(
    "label",
    x = 2.7, y = 268.3, label = "更慢", fill = "#FFFFB2"
  ) +
  annotate(
    "label",
    x = 19.6, y = 244, label = "更快", fill = "#B10026", color = "white"
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
s_ggsave(gg, "plot.png", width = 4.5, height = 3.2)
