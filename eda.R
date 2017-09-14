library(tidyverse)
library(RPostgreSQL)
library(DBI)
library(ggthemr)

ggthemr('fresh')

# connection to the db
con <- dbConnect(drv = PostgreSQL(), host = "/tmp", dbname = "stanford-open-police")

# a viz of total stops by race
all_stops <- 
  con %>% 
  tbl("total_stops") %>% 
  collect() %>% 
  filter(driver_race %in% c("White", "Hispanic", "Black", "Asian", "Other")) %>% 
  mutate(frac = count / sum(count)) 
  
(all_stops_plot <-
  all_stops %>% 
  ggplot(aes(forcats::fct_reorder(driver_race, frac, .desc = TRUE), frac)) +
  geom_col())

  
# a viz for stop rate by race
stops_by_race <-
  con %>% 
  tbl("stop_rate_by_race") %>% 
  collect()

stops_by_race_avg <-
  stops_by_race %>% 
  group_by(driver_race) %>%
  summarize(
    asian_avg_stop_rate = weighted.mean(stop_rate, asian_pop, na.rm = TRUE), 
    black_avg_stop_rate = weighted.mean(stop_rate, black_pop, na.rm = TRUE),
    hispanic_avg_stop_rate = weighted.mean(stop_rate, hispanic_pop, na.rm = TRUE),
    white_avg_stop_rate = weighted.mean(stop_rate, white_pop, na.rm = TRUE)
  )
# really ugly; can be made better
avg_stops <- 
  tibble(
    race = stops_by_race_avg %>% pull(driver_race), 
    avg_stop_rate = c(
      stops_by_race_avg[[1,2]], 
      stops_by_race_avg[[2,3]], 
      stops_by_race_avg[[3,4]], 
      stops_by_race_avg[[4,5]]
    )
  )
(avg_stops_plot <-
  avg_stops %>%
  ggplot(aes(
    forcats::fct_reorder(race, avg_stop_rate, .desc = TRUE), 
    avg_stop_rate * 100
  )) +
  geom_col())
  
stops_by_race %>% 
  group_by(county_name) %>% 
  filter(
    driver_race %in% c("Black", "White"), 
    stop_rate < 0.3
  ) %>% 
  spread(driver_race, stop_rate) %>% 
  summarise(
    White = mean(White, na.rm = TRUE), 
    Black = mean(Black, na.rm = TRUE),
    tot_pop = mean(tot_pop)
  ) %>% 
  ggplot(aes(White, Black)) +
  geom_hex() +
  geom_abline(slope = 1, intercept = 0, color = "black") 
