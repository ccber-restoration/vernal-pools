# The purpose of this script is to process a csv downloaded from Survey123 to prepare it for analysis or visualization
# (typically specific to a project site (aka location))


library(tidyverse)
library(janitor)
library(plotly)
library(scales)
library(cowplot)

# for checking locations of anomalous VP IDs
library(mapview)
library(sf)

# avoid hard-coding variables in the body of the script, below
date_download <- "2026-09-14"

# build filepath for raw vernal pool hydrology data, based on download date
dir <- paste0("data-raw/", date_download, "/CCBER_Vernal_Pool_Hydrology_0.csv")

# read in csv
vp_hydrology <- read_csv(dir, guess_max = 9230) %>%
  #extract date and date-time from "Date" column
  mutate(datetime = as.POSIXct(Date, format="%m/%d/%Y %H:%M")) %>%
  select(-Date) %>%
  mutate(date = date(datetime)) %>%
  clean_names() %>%
  # make sure all pool_id columns are character
  mutate(across(c(pool_id_14:unlisted_pool_id), as.character)) %>%
  # combine pool id columns into one using coalesce()
  mutate(
    vernal_pool_name_or_id = coalesce(
      vernal_pool_name_or_id,
      pool_id_14,
      pool_id_15,
      pool_id_16,
      pool_id_17,
      pool_id_18,
      pool_id_19,
      pool_id_20,
      pool_id_21,
      pool_id_22,
      pool_id_23,
      unlisted_pool_id
    )
  ) %>%
  #create columns for month and year
  mutate(year = year(date),
         month = month(date),
         day = day(date)) %>%
  # create column for wateryear
  mutate(wy = case_when(
    month >= 10 ~ year + 1,
    .default = year
  )) %>%
  # FIXME in SURVEY123
  # made an educated guess about this issue
  mutate(water_level_in = case_when(
    vernal_pool_name_or_id == "8.25" ~ 0.25,
    .default = water_level_in
  )) %>%
  mutate(vernal_pool_name_or_id = case_when(
    vernal_pool_name_or_id == "8.25" ~ "8",
    vernal_pool_name_or_id == "01" ~ "1",
    .default = vernal_pool_name_or_id
  ))

# check unique pool id values (need to be combined with location to uniquely identify pools)
unique(vp_hydrology$vernal_pool_name_or_id)

# write processed data to file

write_rds(file = paste0("data-processed/ncos_vp_hydrology_",
                 date_download, ".rds"),
          vp_hydrology)
