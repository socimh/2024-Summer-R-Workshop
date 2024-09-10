# Goal: Record my Photo Locations
# Input: P60 Photos
# Ouput: photos.html

sessionInfo()

pacman::p_load(
  sf, leaflet, hms, exifr,
  tidyverse, statart
)

# ========== Locations from Photos ========== #
folder <- "D:/Photos/2024"
photos <- list.files(
  pattern = ".(jpg|JPG|PNG)$",
  path = folder,
  full.names = TRUE
)
length(photos)

photo_data <- read_exif(
  photos,
  tags = c(
    "Model", "ISO", "ExposureTime", "FOV", "LightValue",
    "GPSDateTime", "GPSLatitude", "GPSLongitude", "GPSAltitude"
  )
) %>%
  # record the duration (usually it takes <1 second)
  s_time()


# ========== Generate Points Data ========== #
photo_points <- photo_data %>%
  mutate(
    GPSDateTime = as_datetime(GPSDateTime, tz = "Asia/Shanghai"),
    GPSDateTime_num = as.numeric(GPSDateTime),
    GPSYear = GPSDateTime %>% year()
  ) %>%
  filter(!is.na(GPSYear)) %>%
  mutate(
    GPSDate_label = format(GPSDateTime, "%Y-%m-%d (%A)"),
    GPSTime_label = format(GPSDateTime, "%H:%M"),
    label = paste0(
      "<b>日期: </b>", GPSDate_label, "<br/>",
      "<b>时间: </b>", GPSTime_label, "<br/>",
      "<img src=",
      '\"', SourceFile, '\" width=300> <br/>',
      "<font color=\"lightgray\"><i><b>文件名: </b>", SourceFile, "</b></font>"
    )
  ) %>%
  st_as_sf(coords = c("GPSLongitude", "GPSLatitude"))

photo_points %>%
  as_tibble() %>%
  select(label) %>%
  slice(1) %>%
  pull(1)

# ========== Generate Segments Data ========== #
points_to_linestrings <- function(points_sf) {
  lines_sf <- points_sf %>%
    mutate(lead_geometry = lead(geometry)) %>%
    rowwise() %>%
    mutate(geometry = st_union(geometry, lead_geometry)) %>%
    ungroup() %>%
    slice(-n()) %>%
    st_cast("LINESTRING")
  return(lines_sf)
}

photo_segments <- photo_points %>%
  arrange(GPSDateTime) %>%
  mutate(
    lag_GPSDateTime = lag(GPSDateTime),
    diff_GPSDateTime = difftime(GPSDateTime, lag_GPSDateTime, units = "hours") %>% as.numeric()
  ) %>%
  points_to_linestrings() %>%
  mutate(
    distance_km = st_length(.) * 111,
    speed = distance_km / diff_GPSDateTime, # [km/h]
    id = row_number(),
    label = paste0(
      "<b>日期: </b>", GPSDate_label, "<br/>",
      "<b>时间: </b>", GPSTime_label, "<br/>",
      "<b>距离: </b>", sprintf("%.1f", distance_km), " km<br/>",
      "<b>持续时间: </b>", sprintf("%.2f", diff_GPSDateTime), " h<br/>",
      "<b>时速: </b>", sprintf("%.1f", speed), " km/h<br/>",
      "<img src=",
      '\"', SourceFile, '\" width=300> <br/>',
      "<font color=\"lightgray\"><i><b>文件名: </b>", SourceFile, "</b></font>"
    )
  )

# ========== Interactively Visualize Data ========== #
write_leaflet <- function(map, file) {
  class(map) <- c("write_leaflet", class(map))
  attr(map, "filesave") <- file
  print(map)
}

print.write_leaflet <- function(x, ...) {
  class(x) <- class(x)[class(x) != "write_leaflet"]
  htmltools::save_html(x, file = attr(x, "filesave"))
  print("HTML file saved!")
}

start_leaflet <- leaflet(
  width = 1280,
  height = 750,
  options = leafletOptions(
    crs = leafletCRS(code = "EPSG:4490"),
    proj4def = "+proj=longlat +ellps=GRS80 +no_defs"
  )
) %>%
  addProviderTiles(
    "Esri.WorldImagery",
    group = "WorldImagery"
  ) %>%
  addProviderTiles(
    "OpenStreetMap",
    group = "OpenStreetMap"
  ) %>%
  addProviderTiles(
    "Esri.WorldStreetMap",
    group = "WorldStreetMap"
  ) %>%
  addProviderTiles(
    "Esri.WorldGrayCanvas",
    group = "WorldGrayCanvas"
  ) %>%
  addLayersControl(
    baseGroups = c(
      "WorldImagery",
      "OpenStreetMap",
      "WorldStreetMap",
      "WorldGrayCanvas"
    ),
    # position it on the topleft
    position = "topleft"
  ) %>%
  addMiniMap(
    tiles = "OpenStreetMap.HOT",
    # tiles = "Esri.WorldGrayCanvas",
    zoomLevelOffset = -5
  )

start_leaflet

start_leaflet %>%
  addPolylines(
    data = photo_segments,
    popup = ~label
  ) %>%
  addCircleMarkers(
    data = photo_points,
    popup = ~label,
    color = "#00192f",
    weight = 2.5,
    fill = TRUE,
    fillColor = "skyblue",
    fillOpacity = .8,
    radius = 9
  ) %>%
  write_leaflet("D:/R/Teaching/2024 Summer R Workshop/Week 10/photos.html")
