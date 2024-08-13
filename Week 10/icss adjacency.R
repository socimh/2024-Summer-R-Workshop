library(tidyverse)
library(tidytext)
library(tidygraph)
library(ggraph)
library(readxl)
# There is a gsheet.
tb <- read_excel("~/Downloads/Speed Dating.xlsx")

features <- tb %>%
  filter(!is.na(`Research Areas`)) %>%
  select(1, 6, 7) %>%
  rename_with(~ c("name", "major", "area")) %>%
  unite(area, major, area, sep = " ") %>%
  unnest_tokens(feature, area) %>%
  filter(!feature %in% c("science", "and", "of", "governance", "design")) %>%
  group_by(name) %>%
  distinct(feature, .keep_all = T) %>%
  ungroup() %>%
  group_by(feature) %>%
  filter(n() > 1) %>%
  ungroup()

# Visualize Matrix
features %>%
  rename(name2 = name) %>%
  full_join(features, by = "feature") %>%
  mutate(record = 1) %>%
  complete(name, name2, fill = list(record = 0)) %>%
  filter(name != name2) %>%
  group_by(name, name2) %>%
  summarise(similarity = sum(record)) %>%
  ggplot() +
  geom_tile(aes(name, name2, fill = similarity %>% factor() %>% fct_rev())) +
  scale_fill_brewer("Similarity", palette = "YlOrRd", direction = -1) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )
ggsave("adj_mat.jpg", width = 8.5, height = 7.5)

icss_graph <- features %>%
  rename(name2 = name) %>%
  full_join(features, by = "feature") %>%
  mutate(record = 1) %>%
  complete(name, name2, fill = list(record = 0)) %>%
  filter(name != name2) %>%
  group_by(name, name2) %>%
  summarise(similarity = sum(record)) %>%
  filter(similarity > 0) %>%
  mutate(similarity = similarity %>% factor() %>% fct_rev()) %>%
  graph_from_data_frame(directed = F) %>%
  as_tbl_graph() %>%
  activate(nodes) %>%
  mutate(hjust = case_when(
    name %in% c("Siying LV", "Tiantian LI") ~ .2,
    name %in% c("Zhiyun XU", "Wynston LEE") ~ .8,
    TRUE ~ .5
  ))

# Visualize Network
icss_graph %>%
  ggraph() +
  geom_edge_hive(aes(edge_width = similarity, alpha = similarity),
    color = "#333333"
  ) +
  geom_node_label(aes(label = name, hjust = hjust)) +
  scale_edge_width_manual("Similarity", values = 1:4) +
  scale_edge_alpha_manual("Similarity", values = 1:4 * .25) +
  theme_void()
ggsave("icss_network.jpg", width = 9.5, height = 7.5)
