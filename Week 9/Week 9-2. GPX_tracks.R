# Goal: Record my travel trajectories
# Input: GPX files
# Ouput: Maps

pacman::p_load(
  sf, leaflet, ggspatial,
  hms, tidyverse, statart
)

folder <- "D:/R/Teaching/2024 Summer R Workshop/Week 9/Workout GPX"
gpx_files <- list.files(folder, "*.gpx", full.names = TRUE)

# ================= Import GPX =================
# Convert the first GPX file to an sf object
track_points <- gpx_files[2] %>%
  tmaptools::read_GPX(
    layers = "track_points",
    remove.empty.layers = TRUE,
    as.sf = TRUE
  ) %>%
  .$track_points

# ================= Draw Maps with Points =================

# Draw the track points
ggplot() +
  geom_sf(data = track_points)

ggplot() +
  geom_sf(
    data = track_points,
    color = "firebrick"
  )

# Add a map tile
ggplot() +
  annotation_map_tile(type = "osmtransport") +
  geom_sf(
    data = track_points,
    color = "firebrick"
  )

# Vary the color by elevation
ggplot() +
  annotation_map_tile(type = "osmtransport") +
  geom_sf(
    data = track_points,
    # put the time in the aes() function
    aes(color = time)
  ) +
  scale_color_viridis_c(
    option = "F",
    direction = -1
  )

# ================= Manipulate the sf object =================

track_points_cleaned <- track_points %>%
  # Set the CRS to China Geodetic Coordinate System 2000
  st_transform(4490) %>%
  select(track_seg_point_id:time) %>%
  mutate(
    point_id = row_number(),
    lead_time = lead(time),
    duration_sec = as.numeric(lead_time - time)
  )

points_to_linestrings <- function(points_sf) {
  lines_sf <- points_sf %>%
    mutate(lead_geometry = lead(geometry)) %>%
    mutate(geometry = st_union(geometry, lead_geometry)) %>%
    st_cast("LINESTRING") %>%
    mutate(
      distance_m = st_length(.) %>%
        as.numeric()
    ) %>%
    filter(distance_m > 0)
  message("\nPlease ignore the warning messages.")
  return(lines_sf)
}

track_lines <- track_points_cleaned %>%
  points_to_linestrings() %>%
  mutate(
    speed = distance_m / duration_sec
  ) %>%
  filter(speed < 40)

# ================= Draw Maps with Lines =================

ggplot() +
  annotation_map_tile(type = "osmtransport") +
  geom_sf(
    data = track_lines,
    # lwd is the line width
    lwd = 3,
    color = "firebrick"
  )

ggplot() +
  annotation_map_tile(
    type = "osmtransport"
  ) +
  geom_sf(
    data = track_lines,
    aes(
      color = speed,
      lwd = 1 / speed
    )
  ) +
  scale_color_viridis_c(
    option = "F",
    direction = -1
  )


# Theoretically, if there are too many segments/points in the map,
# the map is not easy to read.

# There are three solutions:
# 1. aggregate the segments
#     - aggregating all segments is easy
#     - aggregating by a certain rule is difficult
#       e.g., aggregative every 50 segments and calculate the mean speed
# 2. filter the segments
# 3. draw interactive maps

# The first two solutions are fundamental.


# ================= Solution 3: Draw Interactive Maps =================

# How to build a website
# 1. HTML (HyperText Markup Language)
# 2. CSS (Cascading Style Sheets)
# 3. JavaScript (For interactive elements)

# Draw segments with leaflet
osm_leaflet <- leaflet(
  options = leafletOptions(
    crs = leafletCRS(code = "EPSG:4490")
  )
) %>%
  addProviderTiles(
    # Other options include WorldGreyCanvas, Esri.WorldImagery, etc.
    providers$OpenStreetMap
  )

osm_leaflet %>%
  addPolylines(
    data = track_lines,
    color = "#762495",
    weight = 5,
    opacity = .8
  )

# Vary the line width by speed
osm_leaflet %>%
  addPolylines(
    data = track_lines,
    color = "#762495",
    # Algorithm 1
    weight = ~ (1 - percent_rank(speed)) * 10,
    opacity = .8
  )

osm_leaflet %>%
  addPolylines(
    data = track_lines,
    color = "#762495",
    # Algorithm 2
    weight = ~ 2 / pmax(speed, .1),
    opacity = .8
  )

# Vary the color by speed (not recommended in this case)
pal <- colorQuantile(
  palette = "Purples",
  domain = track_lines$speed,
  reverse = TRUE
)

osm_leaflet %>%
  addPolylines(
    data = track_lines,
    color = ~ pal(speed),
    weight = ~ (1 - percent_rank(speed)) * 10,
    opacity = .8
  )

# ================= Solution 2: Filter Points/Segments =================
stay_points <- track_points_cleaned %>%
  anti_join(track_lines %>% tibble(), by = "point_id") %>%
  filter(duration_sec > 30)

slow_points <- track_points_cleaned %>%
  semi_join(
    track_lines %>%
      tibble() %>%
      filter(speed < 2),
    by = "point_id"
  )

selected_points <- slow_points %>%
  bind_rows(stay_points) %>%
  arrange(point_id)

selected_paths <- selected_points %>%
  points_to_linestrings()

ggplot() +
  annotation_map_tile(type = "osmtransport") +
  geom_sf(
    data = selected_paths,
    color = "firebrick",
    lwd = 1
  ) +
  geom_sf(
    data = selected_points,
    color = "firebrick",
    alpha = .5,
    size = 3
  )

osm_leaflet %>%
  addPolylines(
    data = selected_paths,
    color = "#762495",
    weight = 5,
    opacity = .8
  ) %>%
  addCircleMarkers(
    data = selected_points,
    color = "#762495",
    radius = 5,
    fillOpacity = .5
  )
