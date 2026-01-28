library(tidyverse)
library(mapview)
library(sf)
library(janitor)

#read in pool list ----
pools <- read_csv("data-raw/vernal_pool_ids.csv")
# 74 pools

#define pattern for extracting from string
axis_pattern <- "Major|minor"

# define pattern of words to remove from point_id to be left with just the pool_id (not including location component)
pattern_to_remove <- "Minor|minor|Major|major|Start|End|Enc"

#note that some points also include a direction (N,S,E,W)

#read in points as sf object for mapping
points_sf <-  read_csv("data-raw/CCBER_VernalPool_VegMonitoring_TransectEndpoints.csv") %>%
  st_as_sf(., coords = c("x", "y"), crs = 4326)

#display interactive map
mapview(points_sf)


#read in points (from layer)
points <- read_csv("data-raw/CCBER_VernalPool_VegMonitoring_TransectEndpoints.csv") %>%
  clean_names() %>%
  #extract last word from point id (usually start or end (aka position), but not always)
  mutate(position = word(point_id, -1)) %>%
  #filter out points that are transect ends (just use start points)
  filter(!(position == "End" | position == "end" | position == "Enc")) %>%
  #some pools have more than one axis, just want one point per pool
  #create new variable based on whether the id contains "Major or minor"
  mutate(axis = str_extract(point_id, axis_pattern)) %>%
  #fix axis value for few points with non-standard capitalization
  mutate(axis = case_when(
    point_id == "	6 Minor Start" ~ "minor",
    point_id == "	4 major Start" ~ "Major",
    point_id == "Minor Start" ~ "minor",
    .default = axis
  )) %>%
  # get just the point_id by removing the words "start" "end" "major" and "minor"
  mutate(pool_id = gsub(pattern_to_remove, "", point_id))

# this seems to add whitespace, which I don't want...

  # Note that Sierra Madre doesn't have a point_id bc it's just one pool


#how many major and how many minor?

minor_points <- points %>%
  filter(axis == "minor")
#77 points

major_points <- points %>%
  filter(axis == "Major")
#88 points

#summarize number of points per axis by pool (wont' work perfectly)
pool_axis_summary_ <- points %>%
  group_by(location, pool_id) %>%
  count(axis)

# all pools have 1-2 axes

#number of points per
pool_start_point_summary <- points %>%
  group_by(location, pool_id) %>%
  summarize(n_start_points = n())

#note:

#some pools only have one axis (from because pool_id still contains the point cardinal direction?)
#most pools have two axes (Major + minor)

#a few pools have three starting points:

#
#Del Sol G
#Ellwood Mesa 4
# South Parcel 2
# Storke Ranch 2017
