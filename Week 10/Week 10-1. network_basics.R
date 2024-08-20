pacman::p_load(
  tidygraph,
  ggraph,
  tidyverse,
  statart
)

# Basic concepts
# https://towardsdatascience.com/network-analysis-d734cd7270f8

# 1. nodes (vertices, 节点)
# 2. edges (links, 边)
# 3. directed (有向) and undirected (无向)
# 4. graph theory (图论) is the study of graphs, which are mathematical structures
#    used to model pairwise relations between objects.
# 5. centrality (中心性)

#################### Generate the graph ####################
# highschool data from ggraph
highschool %>%
  as_tibble()

# any mutually connected students?
highschool %>%
  as_tibble() %>%
  filter(from <= 10, to <= 10)

highschool %>%
  as_tibble() %>%
  filter(from %in% 11:20, to %in% 11:20)

# convert to a graph object
highschool_graph <- highschool %>%
  as_tbl_graph(directed = TRUE)

highschool_graph
highschool_graph %>% s_type() # It is a tbl_graph object


#################### Manipulate the graph ####################
# calculate centrality
highschool_graph <- highschool_graph %>%
  # activate() is used to switch between nodes and edges
  activate(nodes) %>%
  mutate(
    degree_centrality = centrality_degree(),
    closeness_centrality = centrality_closeness(),
    between_centrality = centrality_betweenness(),
    eigen_centrality = centrality_eigen()
  )

# showcase the edge and graph statistics
highschool_graph %>%
  activate(edges) %>%
  mutate(
    radius = graph_radius(),
    dist = graph_mean_dist(),
    mutual = edge_is_mutual(),
    mutual_mean = graph_reciprocity()
  )


#################### Visualize the graph ####################
# A graph with only edges
highschool_graph %>%
  ggraph() +
  geom_edge_link() +
  theme_void()

# A graph with only nodes
highschool_graph %>%
  ggraph() +
  geom_node_point() +
  theme_void()

# A graph with both nodes and edges
highschool_graph %>%
  ggraph() +
  geom_edge_link() +
  geom_node_point() +
  theme_void()

# prettify the graph
highschool_graph %>%
  ggraph() +
  geom_edge_link(color = "gray", alpha = .5) +
  geom_node_point(aes(size = between_centrality, alpha = between_centrality)) +
  theme_void()

# Control the modifiable aesthetics
highschool_graph %>%
  ggraph() +
  geom_edge_link(color = "gray", alpha = .5) +
  geom_node_point(aes(size = between_centrality, alpha = between_centrality)) +
  # size between 1 and 8
  scale_size_continuous(range = c(1, 8)) +
  theme_void()

# Add labels to the nodes
# This step is optional
highschool_graph %>%
  ggraph() +
  geom_edge_link(color = "gray", alpha = .5) +
  geom_node_point(aes(size = between_centrality, alpha = between_centrality)) +
  geom_node_text(aes(label = name), color = "white") +
  scale_size_continuous(range = c(1, 8)) +
  theme_void()

# Change the layout
# This step is optional
highschool_graph %>%
  # Other layout options: linear, matrix, fr, etc.
  ggraph(layout = "kk") +
  geom_edge_link(color = "gray", alpha = .5) +
  geom_node_point(aes(size = between_centrality, alpha = between_centrality)) +
  geom_node_text(aes(label = name), color = "white") +
  scale_size_continuous(range = c(1, 8)) +
  theme_void()
