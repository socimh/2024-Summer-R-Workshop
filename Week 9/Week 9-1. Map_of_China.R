# Goal: Record my traveled cities in China
# Input: Shapefiles and
# Ouput: Maps

 pacman::p_load(
  sf, ggspatial, ggthemes, cowplot,
  tidyverse, statart
)

master_folder <- "D:/R/Teaching/2024 Summer R Workshop/Week 9/China Shapefiles"

read_and_convert_sf <- function(folder_name, file_name) {
  output_sf <- paste(folder_name, file_name, sep = "/") %>%
    st_read(quiet = TRUE) %>%
    rename_with(tolower) %>%
    # Set the projection to EPSG:4490 (China Geodetic Coordinate System 2000)
    st_transform(4490)
  print(output_sf)
  return(output_sf)
}

# 行政区划来自 http://horizon2021.xyz/
cncity <- master_folder %>%
  paste0("/City Boundary") %>%
  read_and_convert_sf("city.shp") %>%
  rename(
    city = 地市,
    prov = first_省区
  )
cnprov <- master_folder %>%
  paste0("/City Boundary") %>%
  read_and_convert_sf("province.shp")

# 下面的数据来自 http://gaohr.win/site/blogs/2017/2017-04-18-GIS-basic-data-of-China.html
# Boundary
cnboundary_land <- master_folder %>%
  paste0("/China Boundary") %>%
  read_and_convert_sf("CN-boundary-land.shp")
cnboundary_sea <- master_folder %>%
  paste0("/China Boundary") %>%
  read_and_convert_sf("CN-boundary-sea.shp")

# South China Sea
southsea_nine_dash <- master_folder %>%
  paste0("/South Sea") %>%
  read_and_convert_sf("nine_dash_line.shp")
southsea_islands <- master_folder %>%
  paste0("/South Sea") %>%
  read_and_convert_sf("islands.shp")



# ================= How to Plot the Map =================

# About the data
cnprov
cnprov %>%
  class()

cnprov %>%
  tibble()

cnprov %>%
  tibble() %>%
  class()


# A traditional ggplot
# ggplot(data) +
#   aes(x, y) +
#   geom_point()

# A simple map
ggplot(cnprov) +
  geom_sf()

ggplot() +
  # I prefer to specify the data argument in each geom
  geom_sf(data = cnprov)

ggplot() +
  geom_sf(data = southsea_nine_dash)

# Add two layers in one map
ggplot() +
  geom_sf(data = cnprov) +
  geom_sf(data = southsea_nine_dash)

# Add more layers
ggplot() +
  geom_sf(data = cnprov) +
  geom_sf(data = cnboundary_land, lwd = 1) +
  geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
  geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
  geom_sf(data = southsea_islands, color = "#444444")

# Use arguments to customize the plot
(gg <- ggplot() +
  geom_sf(
    data = cnprov,
    fill = NA, # No fill (transparent)
    color = "darkgray", # Border color
    lwd = .3 # Border width
  ) +
  geom_sf(data = cnboundary_land, lwd = 1) +
  geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
  geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
  geom_sf(data = southsea_islands, color = "#444444"))

# (x <- y) is equivalent to x <- y, and then print x
1 + 1 # return the result only
x <- 1 + 1 # assign the result to x only
(x <- 1 + 1) # assign the result to x and print x

# Change the coordinate system
# This makes the map look less distorted
gg +
  coord_sf(
    ylim = c(-2387082, 1654989),
    # x = longitude 经度
    xlim = c(-3700000, 1400000), # Adjust the limits of the longitude
    crs = "+proj=laea +lat_0=40 +lon_0=116" # Adjust the central point
  )

gg +
  coord_sf(
    ylim = c(-2387082, 1654989),
    xlim = c(-2500000, 3100000),
    crs = "+proj=laea +lat_0=40 +lon_0=104"
  )

# Recall ...
diamonds %>%
  sample_n(1000) %>%
  set_seed(20240813) %>%
  ggplot() +
  aes(x = carat, y = price) +
  geom_point() +
  # coord_...() is used to change the coordinate system
  coord_flip()

# Change the breaks of the longitude
(gg <- gg +
  coord_sf(
    ylim = c(-2387082, 1654989),
    xlim = c(-2500000, 3100000),
    crs = "+proj=laea +lat_0=40 +lon_0=104"
  ) +
  # x = longitude
  scale_x_continuous(breaks = seq(80, 130, 10)))

# Add a scale bar 比例尺
gg +
  annotation_scale()

gg +
  # Adjust the position of the scale bar
  annotation_scale(
    location = "bl", # bottom left
    pad_x = unit(1, "cm"),
    pad_y = unit(.5, "cm")
  )

# Add a north arrow
gg +
  annotation_north_arrow()

gg +
  annotation_north_arrow(
    style = north_arrow_fancy_orienteering()
  )

gg +
  annotation_north_arrow(
    style = north_arrow_fancy_orienteering(),
    location = "tl", # top left
    height = unit(2, "cm"),
    width = unit(2, "cm")
  )

gg +
  annotation_north_arrow(
    style = north_arrow_fancy_orienteering(),
    location = "tl",
    height = unit(2, "cm"),
    width = unit(2, "cm"),
    pad_x = unit(1, "cm"),
    pad_y = unit(1, "cm")
  )

# Add a base map (Internet connection required)
gg +
  # Choose the type "osmtransport"
  # There are many options, but most of them actually do not work
  annotation_map_tile(type = "osmtransport")

ggplot() +
  # Typically, the base map is added first
  annotation_map_tile(type = "osmtransport") +
  geom_sf(
    data = cnprov,
    fill = NA,
    color = "darkgray",
    lwd = .3
  )


# Change the theme
gg +
  theme_void()

gg +
  theme_map()


# ================= Map with Colors =================

cnprov

###################### Map with a single color ######################
selected_prov <- cnprov %>%
  filter(between(shape_area, 15, 16))

# Wrong
ggplot() +
  geom_sf(
    data = selected_prov,
    fill = "firebrick"
  )

# Correct
ggplot() +
  geom_sf(
    data = cnprov,
    fill = NA,
    color = "lightgray",
    lwd = .15
  ) +
  geom_sf(
    data = selected_prov,
    fill = "firebrick"
  )+
  theme_bw()


###################### Map with multiple colors ######################
ggplot() +
  geom_sf(
    data = cnprov,
    # always call aes() when mapping a variable to a color
    aes(fill = shape_area),
    color = "lightgray",
    lwd = .15
  )

ggplot() +
  geom_sf(
    data = cnprov,
    # always call aes() when mapping a variable to a color
    aes(fill = shape_area),
    color = "lightgray",
    lwd = .15
  ) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1)

cnprov %>%
  mutate(
    area_5g = cut_quantile(shape_area, n = 5)
  ) %>%
  ggplot() +
  geom_sf(
    aes(fill = area_5g),
    color = "lightgray",
    lwd = .15
  ) +
  scale_fill_brewer(palette = "YlOrRd", direction = 1)

cnprov %>%
  mutate(
    area_5g = cut_length(shape_area, n = 5)
  ) %>%
  ggplot() +
  geom_sf(
    aes(fill = area_5g),
    color = "lightgray",
    lwd = .15
  ) +
  scale_fill_brewer(palette = "YlOrRd", direction = 1)


# ================= Write Functions =================

###################### Map with a single color ######################
travel_plot <- function(data, fill = "firebrick") {
  cncity_visit <- cncity %>%
    mutate(
      city = if_else(
        str_detect(prov, "香港|澳门"),
        prov, city
      )
    ) %>%
    left_join(
      data,
      by = "city"
    ) %>%
    mutate(
      visit = !is.na(visit_year)
    )

  g1 <- ggplot() +
    annotation_map_tile(type = "osmtransport") +
    geom_sf(
      data = cncity_visit,
      aes(fill = visit),
      color = "lightgray",
      lwd = .15
    ) +
    geom_sf(
      data = cnprov,
      fill = NA,
      color = "darkgray",
      lwd = .3
    ) +
    geom_sf(data = cnboundary_land, lwd = 1) +
    geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
    geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
    geom_sf(data = southsea_islands, color = "#444444") +
    coord_sf(
      ylim = c(-2387082, 1654989),
      xlim = c(-2500000, 3100000),
      crs = "+proj=laea +lat_0=40 +lon_0=104"
    ) +
    scale_fill_manual(values = c("white", fill)) +
    annotation_scale(
      location = "bl",
      pad_x = unit(1, "cm"),
      pad_y = unit(.5, "cm")
    ) +
    annotation_north_arrow(
      style = north_arrow_fancy_orienteering(),
      location = "tl",
      height = unit(2, "cm"),
      width = unit(2, "cm"),
      pad_x = unit(1, "cm"),
      pad_y = unit(1, "cm")
    ) +
    theme_void() +
    theme(
      axis.line = element_blank(),
      panel.border = element_blank(),
      legend.position = "none"
    )

  g2 <- ggplot() +
    annotation_map_tile(type = "osmtransport", zoom = 2) +
    geom_sf(
      data = cncity_visit,
      aes(fill = visit),
      color = "lightgray",
      lwd = .15
    ) +
    geom_sf(
      data = cnprov,
      fill = NA,
      color = "darkgray",
      lwd = .3
    ) +
    geom_sf(data = cnboundary_land, lwd = 1) +
    geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
    geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
    geom_sf(data = southsea_islands, color = "#444444") +
    coord_sf(
      ylim = c(-4028017, -1877844),
      xlim = c(117131.4, 2115095),
      crs = "+proj=laea +lat_0=40 +lon_0=104"
    ) +
    scale_fill_manual(values = c("white", fill)) +
    scale_x_continuous(breaks = 120) +
    scale_y_continuous(breaks = 0:2 * 10) +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(
        fill = NA,
        color = "grey10",
        linetype = 1,
        linewidth = 1
      ),
      plot.margin = unit(c(0, 0, 0, 0), "mm"),
      legend.position = "none"
    )

  ggdraw() +
    draw_plot(g1) +
    draw_plot(
      g2,
      x = 0.79,
      y = -.13,
      width = 0.2,
      height = 0.6
    )
}

file <- str_glue("{master_folder}/visited_cities.xlsx")
my_cities <- read_data(file) %>%
  filter(visit_year >= 2023)
my_cities

# my_cities <- read_data(file) %>%
#   filter(visit_year >= 2014)

travel_plot(my_cities)
ggsave("D:/R/Teaching/2024 Summer R Workshop/Week 9/travelmap.png", width = 12, height = 8.67)


###################### Map with multiple colors ######################

travel_plot_by_var <- function(data, var, palette = "YlOrRd") {
  cncity_visit <- cncity %>%
    mutate(
      city = if_else(
        str_detect(prov, "香港|澳门"),
        prov, city
      )
    ) %>%
    right_join(
      data,
      by = "city"
    ) %>%
    mutate(
      visit = !is.na(visit_year)
    )

  g1 <- ggplot() +
    annotation_map_tile(type = "osmtransport") +
    geom_sf(
      data = cncity_visit,
      aes(fill = {{ var }}),
      color = "lightgray",
      lwd = .15
    ) +
    geom_sf(
      data = cnprov,
      fill = NA,
      color = "darkgray",
      lwd = .3
    ) +
    geom_sf(data = cnboundary_land, lwd = 1) +
    geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
    geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
    geom_sf(data = southsea_islands, color = "#444444") +
    coord_sf(
      ylim = c(-2387082, 1654989),
      xlim = c(-2500000, 3100000),
      crs = "+proj=laea +lat_0=40 +lon_0=104"
    ) +
    scale_fill_distiller(palette = palette, direction = 1) +
    annotation_scale(
      location = "bl",
      pad_x = unit(1, "cm"),
      pad_y = unit(.5, "cm")
    ) +
    annotation_north_arrow(
      style = north_arrow_fancy_orienteering(),
      location = "tl",
      height = unit(2, "cm"),
      width = unit(2, "cm"),
      pad_x = unit(1, "cm"),
      pad_y = unit(1, "cm")
    ) +
    theme_void() +
    theme(
      axis.line = element_blank(),
      panel.border = element_blank(),
      legend.position = "none"
    )

  g2 <- ggplot() +
    annotation_map_tile(type = "osmtransport", zoom = 2) +
    geom_sf(
      data = cncity_visit,
      aes(fill = {{ var }}),
      color = "lightgray",
      lwd = .15
    ) +
    geom_sf(
      data = cnprov,
      fill = NA,
      color = "darkgray",
      lwd = .3
    ) +
    geom_sf(data = cnboundary_land, lwd = 1) +
    geom_sf(data = cnboundary_sea, color = "#444444", lwd = .05) +
    geom_sf(data = southsea_nine_dash, color = "black", lwd = 1) +
    geom_sf(data = southsea_islands, color = "#444444") +
    coord_sf(
      ylim = c(-4028017, -1877844),
      xlim = c(117131.4, 2115095),
      crs = "+proj=laea +lat_0=40 +lon_0=104"
    ) +
    scale_fill_distiller(palette = palette, direction = 1) +
    scale_x_continuous(breaks = 120) +
    scale_y_continuous(breaks = 0:2 * 10) +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(
        fill = NA,
        color = "grey10",
        linetype = 1,
        linewidth = 1
      ),
      plot.margin = unit(c(0, 0, 0, 0), "mm"),
      legend.position = "none"
    )

  ggdraw() +
    draw_plot(g1) +
    draw_plot(
      g2,
      x = 0.79,
      y = -.13,
      width = 0.2,
      height = 0.6
    )
}

my_cities <- read_data(file) %>%
  filter(visit_year >= 2014)
travel_plot_by_var(my_cities, visit_year)

ggsave(
  "D:/R/Teaching/2024 Summer R Workshop/Week 9/travelmap_year.png",
  width = 12, height = 8.67
)
