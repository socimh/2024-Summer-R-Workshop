pacman::p_load(
  tidytext,
  tidygraph, ggraph,
  tidyverse, statart
)

#################### Prepare Data ####################
tb <- read_data("D:/R/Teaching/2024 Summer R Workshop/Week 10/Participant Information.xlsx")
tb

features_tb <- tb %>%
  filter(!is.na(`Research Areas`)) %>%
  rename_with(~ c("name", "major", "area", "software")) %>%
  select(1:3) %>%
  unite(area, major, area, sep = " ") %>%
  unnest_tokens(feature, area) %>% # from tidytext
  # Remove some common words
  filter(!feature %in% c("science", "and", "of", "governance", "design")) %>%
  # Deduplicate 对每个人去重
  group_by(name) %>%
  distinct(feature, .keep_all = TRUE) %>%
  ungroup() %>%
  # Only keep features that appear more than once
  filter(n() > 1, .by = feature)


#################### Visualize Data as a Matrix ####################
network_tb <- features_tb %>%
  rename(from = name) %>%
  full_join(
    features_tb %>%
      rename(to = name),
    by = "feature", relationship = "many-to-many"
  ) %>%
  mutate(record = 1) %>%
  complete(from, to, fill = list(record = 0)) %>%
  filter(from != to) %>%
  summarise(similarity = sum(record), .by = c(from, to)) %>%
  # from this row on, we are simply reordering the factors
  mutate(from_mean_similarity = mean(similarity), .by = from) %>%
  mutate(to_mean_similarity = mean(similarity), .by = to) %>%
  mutate(
    from = from %>% fct_reorder(-from_mean_similarity),
    to = to %>% fct_reorder(-to_mean_similarity)
  ) %>%
  select(-from_mean_similarity, -to_mean_similarity)

network_tb %>%
  ggplot() +
  geom_tile(aes(from, to, fill = similarity %>% factor() %>% fct_rev())) +
  scale_fill_brewer("Similarity", palette = "YlOrRd", direction = -1) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )
# ggsave("adj_mat.jpg", width = 8.5, height = 7.5)

#################### Visualize Data as a Graph ####################
graph <- network_tb %>%
  as_tbl_graph(directed = FALSE)

# To view more rows
graph %>%
  activate(edges) %>%
  as_tibble() %>%
  print(n = 20)

graph %>%
  activate(edges) %>%
  as_tibble() %>%
  print_interval()


# Visualize Network
graph %>%
  ggraph() +
  geom_edge_hive(aes(edge_width = similarity, alpha = similarity),
    color = "#4D4A44"
  ) +
  geom_node_label(aes(label = name)) +
  theme_void()
png_path <- "D:/R/Teaching/2024 Summer R Workshop/Week 10/participants_network.png"
ggsave(png_path, width = 9.5, height = 7.5)


# Remove Weak Connections
graph %>%
  activate(edges) %>%
  filter(as_numeric(similarity) > 1) %>% # remove weak connections
  mutate(similarity = factor(similarity)) %>%
  activate(nodes) %>%
  filter(!node_is_isolated()) %>% # remove isolated nodes
  ggraph() +
  geom_edge_hive(
    aes(edge_width = similarity, alpha = similarity),
    color = "#4D4A44"
  ) +
  geom_node_label(aes(label = name)) +
  theme_void()
ggsave(png_path, width = 9.5, height = 7.5, bg = "white")

# Visualize in a Linear Layout
graph %>%
  activate(edges) %>%
  filter(similarity > 2) %>%
  mutate(similarity = factor(similarity)) %>%
  ggraph(layout = "matrix") +
  geom_edge_arc(aes(edge_width = similarity, alpha = similarity),
    color = "#4D4A44"
  ) +
  geom_node_label(aes(label = name)) +
  theme_void()
