library(rtweet)
library(tidyverse)
library(skimr)
library(lubridate)
library(googlesheets4)
library(fuzzyjoin)


# import previous curator ------------------------------------------------------
sheets <- c("2022")

drive_sheet <- "https://docs.google.com/spreadsheets/d/13NwIphQ6o-3YJUbHtbDRf4texfMOCvhIDNZgDZhHv7U/edit#gid=1322160368"

previous_curators_raw <- map_df(
  .x = sheets,
  .f = read_sheet,
  ss = drive_sheet
) 



previous_curators <- previous_curators_raw %>% 
  janitor::clean_names() %>% 
  select(1:5) %>% 
  filter(!curator %in% c(NA, "BREAK", "-"))


# retrieve tweets --------------------------------------------------------------
# one time authentication
# auth_setup_default()

# rladies_tweets_raw <- get_timeline("WeAreRLadies", n = 2000)
# save(rladies_tweets_raw, file = "tweets2022.rda")

load("tweets2022.rda")

rladies_tweets_raw |> 
  glimpse()

rladies_tweets <- rladies_tweets_raw |> 
  mutate(
    this_year = interval(as_date("2022-01-01"), as_date("2022-12-31")),
    in_this_year = created_at %within% this_year,
    url = glue::glue("https://twitter.com/WeAreRLadies/status/{id_str}") 
  ) |> 
  filter(in_this_year) 


# merge tweets with curators ---------------------------------------------------

top_tweets <- rladies_tweets |> 
  fuzzy_left_join(
    previous_curators, 
    by = c(
      "created_at" = "week_start",
      "created_at" = "week_end"
    ),
    match_fun = list(`>=`, `<=`)
  ) |> 
  group_by(curator) |> 
  mutate(max_favorite = max(favorite_count, na.rm = TRUE)) |> 
  ungroup() |> 
  filter(max_favorite == favorite_count | is.na(curator)) |> 
  arrange(desc(favorite_count)) 


