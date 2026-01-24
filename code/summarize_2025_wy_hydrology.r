library(tidyverse)
library(janitor)
library(plotly)
library(scales)
library(cowplot)


#plot vp depth ----

#read in vernal pool hydrology data
vp_hydrology <- read_csv("data-raw/CCBER_Vernal_Pool_Hydrology_0.csv") %>%
  #extract date and date-time from "Date" column
  mutate(datetime = as.POSIXct(Date, format="%m/%d/%Y %H:%M")) %>%
  select(-Date) %>%
  mutate(date = date(datetime)) %>%
  clean_names() %>%
  select(-c(unlisted_location)) %>%
  #create columns for month and year
  mutate(year = year(date),
         month = month(date),
         day = day(date)) %>%
  #create column for wateryear
  mutate(wy = case_when(
    month >= 10 ~ year + 1,
    .default = year
  ))

unique(vp_hydrology$vernal_pool_name_or_id)


#filter data to just ncos & 2025 water year
vp_ncos_2025_wy <- vp_hydrology %>%
  filter(location == "ncos"
           #&wy == 2025
           )


#plot water depth in 2025 wy for ncos vernal pools
fig_vp_depth <- ggplot(data = vp_ncos_2025_wy, aes(x = date, y = water_level_in, color = vernal_pool_name_or_id)) +
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
  theme(legend.position = "none")

fig_vp_depth

ggplotly(fig_vp_depth)


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
       filename = paste("figures/wy_2025_vp_hydrograph",
                        format(Sys.time(), "%Y-%m-%d"),
                        ".pdf"),


       width = 7,
       #height = 5,
       units = "in")



