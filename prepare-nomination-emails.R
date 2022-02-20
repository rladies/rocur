library(tidyverse)
library(googlesheets4)
library(labelled)
library(glue)
library(lubridate)

# import raw nominations data
dat_raw <- read_sheet("https://docs.google.com/spreadsheets/d/1c4nrPOLudgqJri36P4imWJdJy-HIRXrK_1VeHV62RS8/edit?resourcekey#gid=112245468")

# new variable names
var_names <- paste0("Q", 1:12)

# variable labels
labels <- names(dat_raw) %>% 
  rlang::set_names(var_names)


dat <- dat_raw %>% 
  set_names(var_names) %>% 
  labelled::set_variable_labels(!!!labels) %>% 
  mutate(Q1 = as_date(Q1))


data <- dat[1,]

nominee <- glue("{Q6}_{Q5}_{Q1}.txt")

message <- 
  glue("To: {data$Q8} \n\n") %>% 
  glue("CC: {data$Q4} \n\n") %>% 
  glue("Dear {data$Q5}, \n\n") %>% 
  glue("We are pleased to share that {data$Q2} {data$Q3} has nominated you to curate for @WeAreRLadies on Twitter!\n\n") %>% 
  glue("{data$Q2} thinks you would make an excellent curator because: {data$Q10} \n\n" ) %>% 
  glue("Some potential topics that {data$Q2} suggests you could discuss include: {data$Q11} \n\n" ) %>% 
  glue("We would be very happy to have you serve as a curator! If you would like more information prior to making a decision, please read the Rotating Curator Guide (https://guide.rladies.org/rocur/) and experiences from previous curators (https://guide.rladies.org/rocur/guide/#work-from-previous-curators--the-wearerladies-team).\n\n") %>% 
  glue("If you are ready to sign up please review our current schedule of curators (https://tinyurl.com/wearerladies-schedule) and submit the sign up form (https://tinyurl.com/wearerladies-sign-up), which takes approximately 20 minutes to complete.\n\n") %>% 
  glue("Thank you for considering curating for @WeAreRLadies! (https://twitter.com/WeAreRLadies)")

Nomination form https://tinyurl.com/wearerladies-nominate
Sign up form https://tinyurl.com/wearerladies-sign-up
Schedule https://tinyurl.com/wearerladies-schedule
