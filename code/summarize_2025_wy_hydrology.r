library(tidyverse)
library(janitor)
library(plotly)
library(scales)
library(cowplot)

# for checking locations of anomalous VP IDs
library(mapview)
library(sf)

# set download date

wy_current <- 2025

vp_hydrology <- read_rds("data-processed/ncos_vp_hydrology_2026-09-14.rds")

#filter data to just ncos & 2025 water year
vp_ncos_2025_wy <- vp_hydrology %>%
  filter(location == "ncos"
           & wy == 2025) %>%
  # There were measurements on 2024-11-22 and 2024-12-09
  # due to an irrigation leak that left standing water in VP-05
  # Filter these out
  filter(date > as.Date("2025-01-01")) %>%
  mutate(VP = vernal_pool_name_or_id) %>%
  filter(vernal_pool_name_or_id != 9)


vp_data_sf <- st_as_sf(vp_ncos_2025_wy, coords = c("x","y"))

mapview(vp_data_sf)

# plot water depth in 2025 wy for ncos vernal pools
fig_vp_depth <- ggplot(data = vp_ncos_2025_wy, aes(x = date, y = water_level_in, color = VP)) +
  geom_line(
    #linetype = "dashed"
    ) +
  geom_point() +
  scale_x_date(date_breaks = "1 month",
               date_labels = "%b",
               limits = c(as.Date("2024-11-15"), as.Date("2025-05-01"))) +
  theme_cowplot() +
  ylab("Water level (in)") +
  xlab("Date") +
  labs(title = "Vernal pool hydrology (2024-2025 water year)") +
  theme(legend.position = "top")


fig_vp_depth


#plot precipitation ----

#read in rainfall data
#read in NOAA daily summaries
daily_rain <- read_csv(file = "data-raw/NOAA_daily_summaries_USW00053152_full_2025-12-09.csv") %>%
  clean_names() %>%
  #create columns for month and year
  mutate(year = year(date),
         month = month(date),
         day = day(date)) %>%
  #create column for wateryear
  mutate(wy = case_when(
    month >= 10 ~ year + 1,
    .default = year
  ))

rain_wy_2025 <- daily_rain %>%
  filter(wy == 2025)

fig_precip <- ggplot(data = rain_wy_2025, aes(x = date, y = prcp)) +
  geom_col(color = "darkblue") +
  ylab("Daily rainfall (in)") +
  xlab("Date") +
  scale_x_date(breaks = "1 months", date_labels = "%b",
               limits = c(as.Date("2024-11-15"), as.Date("2025-05-01"))) +
  scale_y_continuous(expand = c(0,0)) +
  theme_cowplot()

fig_precip

#combine water depth and precip
fig_vp_hydrograph <- plot_grid(
  fig_vp_depth,
  fig_precip,
  nrow = 2,
  align = "v"
  )

fig_vp_hydrograph

#write to file
ggsave(fig_vp_hydrograph,
       filename = paste0("figures/2025/wy_2025_vp_hydrograph",
                        format(Sys.time(), "%Y-%m-%d"),
                        ".pdf"),


       width = 7,
       height = 5.5,
       units = "in")



# examine first and last days of inundation by VP and water year
inundation_2025 <- vp_ncos_2025_wy %>%
  filter(water_level_in > 0) %>%
  group_by(vernal_pool_name_or_id) %>%
  summarize(date_first = min(date),
            date_last = max(date)) %>%
  ungroup() %>%
  mutate(wet_interval = date_last- date_first)


inundation_days <- vp_hydrology %>%
  filter(location == "ncos") %>%
  filter(wy < 2026) %>%
  filter(vernal_pool_name_or_id != "West Pond") %>%
  filter(vernal_pool_name_or_id != "West pond") %>%
  filter(vernal_pool_name_or_id != "Western pond") %>%
  filter(vernal_pool_name_or_id %in% c("1", "2", "3", "4", "5", "6", "7", "8", "9")) %>%
  filter(water_level_in > 0) %>%
  filter(date != as.Date("2024-11-22")) %>%
  # filter out VP 9
  filter(vernal_pool_name_or_id != 9) %>%
  group_by(vernal_pool_name_or_id, wy) %>%
  summarize(date_first = min(date),
            date_last = max(date)) %>%
  ungroup() %>%
  # calculate wet interval and add 7 days
  # this assumes that on average, the pools already had standing water 3.5 days before the first measurement,
  # and retained water 3.5 days after the last measurement
  mutate(wet_interval = (date_last - date_first) + 7) %>%
  mutate(Vernal_Pool = vernal_pool_name_or_id) %>%
  mutate(wy_factor = as.factor(wy))


# recreate inundation figure

# by year (temporal patterns)
fig_inundation_all_years <- ggplot(data = inundation_days, aes(x = wy, y = wet_interval, fill = Vernal_Pool)) +
  geom_col(position = position_dodge()) +
  scale_y_continuous(limits = c(0,NA), expand = c(0,0)) +
  scale_x_continuous(breaks = seq(2019,2025, by = 1)) +
  xlab("Water year") +
  ylab("Inundation period (days)") +
  theme_cowplot() +
  geom_hline(yintercept = 100, linetype = "dashed")


fig_inundation_all_years

ggsave(fig_inundation_all_years,
       filename = paste0("figures/2025/vp_inundation_period_",
                        format(Sys.time(), "%Y-%m-%d"),
                        ".png"),
       bg = "white",
       width = 7,
       height = 5,
       units = "in")


# by pool (not really useful)

fig_inundation_by_pool <- ggplot(data = inundation_days, aes(x = Vernal_Pool, y = wet_interval, fill = wy_factor)) +
  geom_col(position = position_dodge()) +
  scale_y_continuous(limits = c(0,200), expand = c(0,0)) +
  xlab("Vernal Pool") +
  ylab("Inundation period (days)") +
  theme_cowplot() +
  geom_hline(yintercept = 100, linetype = "dashed")

fig_inundation_by_pool


