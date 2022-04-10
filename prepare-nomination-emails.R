library(tidyverse)
library(googlesheets4)
library(labelled)
library(glue)
library(here)
library(lubridate)
library(janitor)

last_checked <- "2022-03-29"

# Note: google sheets will likely ask you to authenticate prior to importing

# read in helper function ------------------------------------------------------
source(here("R", "helpers.R"))

# import previous curator ------------------------------------------------------
sheets <- c("2022", "2021-ARCHIVE", "2020-ARCHIVE", "2019-ARCHIVE", "2018-ARCHIVE")

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
 



# import raw nominations data --------------------------------------------------
dat_raw <- read_sheet("https://docs.google.com/spreadsheets/d/1c4nrPOLudgqJri36P4imWJdJy-HIRXrK_1VeHV62RS8/edit?resourcekey#gid=112245468")

# new variable names
var_names <- paste0("Q", 1:12)

# variable labels
labels <- names(dat_raw) %>% 
  rlang::set_names(var_names)


dat_clean <- dat_raw %>% 
  set_names(var_names) %>% 
  labelled::set_variable_labels(!!!labels) %>% 
  mutate(
    Q1 = as_date(Q1),
    draft_name = glue("{Q6}_{Q5}_{Q1}.txt"),
    nominee = glue("{Q5} {Q6}"),
    # this is unlikely to be an exact match - could use improvement
    # check to see if nominee has already curated
    check = nominee %in% previous_curators$curator,
    optional_text = case_when(
      !is.na(Q11) ~ glue("Some potential topics that {Q3} suggests you could discuss include: {Q11} \n\n" ),
      is.na(Q11)  ~ glue("") 
  ))
  
  
# view any entries that did not consent ----------------------------------------
dat_clean %>% 
  filter(Q12 != "Yes, I consent.")  

# view any nominations of previous curators ------------------------------------
dat_clean %>% 
  filter(check)  
  

dat_emails <- dat_clean %>% 
  # only look at nominations after last checked
  filter(Q1 > as_date(last_checked)) %>% 
  # remove any previous curators
  # filter(!check) %>% 
  # keep only those who consent
  filter(Q12 == "Yes, I consent.") %>% 
  group_by(draft_name) %>% 
  nest() %>% 
  mutate(
    draft_email = purrr::map(data, compose_email)
    ) %>% 
  ungroup()



# create a local folder named drafts to store email drafts
# drafts are in .gitignore and will not be pushed to github
# if local folder does not exist then create it
folder <- "drafts"
if (!file.exists(here(folder))) dir.create(file.path(here(folder)))

# export draft emails to local folder
purrr::map2(
  .x = dat_emails$draft_email,
  .y = here::here("drafts", dat_emails$draft_name),
  .f = write_lines
)



