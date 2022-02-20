library(tidyverse)
library(googlesheets4)
library(labelled)
library(glue)
library(lubridate)



compose_email <- function(data) {
  glue("To: {data$Q8} \n\n") %>% 
    glue("CC: {data$Q4} \n\n") %>% 
    glue("\n\n") %>% 
    glue("Dear {data$Q5}, \n\n") %>% 
    glue("\n\n") %>% 
    glue("We are pleased to share that {data$Q3} {data$Q2} has nominated you to curate for @WeAreRLadies (https://twitter.com/WeAreRLadies) on Twitter!\n\n") %>% 
    glue("\n\n") %>% 
    glue("{data$Q3} thinks you would make an excellent curator because: {data$Q10} \n\n" ) %>% 
    glue("\n\n") %>% 
    glue("Some potential topics that {data$Q3} suggests you could discuss include: {data$Q11} \n\n" ) %>% 
    # can't get this to work correctly  
    #purrr::when(!is.na(data$Q11) ~ glue("Some potential topics that {data$Q3} suggests you could discuss include: {data$Q11} \n\n" ), ~glue("\n\n")) %>% 
    glue("\n\n") %>% 
    glue("We would be very happy to have you serve as a curator! If you would like more information prior to making a decision, please read the Rotating Curator Guide (https://guide.rladies.org/rocur/) and experiences from previous curators (https://guide.rladies.org/rocur/guide/#work-from-previous-curators--the-wearerladies-team).\n\n") %>% 
    glue("\n\n") %>% 
    glue("If you are ready to sign up please review our current schedule of curators (https://tinyurl.com/wearerladies-schedule) and submit the sign up form (https://tinyurl.com/wearerladies-sign-up), which takes approximately 20 minutes to complete.\n\n") %>% 
    glue("\n\n") %>% 
    glue("Thank you for considering curating for @WeAreRLadies!") %>% 
    glue("\n\n") %>%
    glue("\n\n") %>% 
    glue("The RoCur Team\n\n") %>% 
    glue("Katherine Simeon, Emmanuelle Nunes, & Shannon Pileggi")
}


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
  mutate(
    Q1 = as_date(Q1),
    draft_name = glue("{Q6}_{Q5}_{Q1}.txt")
  ) %>% 
  group_by(draft_name) %>% 
  nest() %>% 
  mutate(
    draft_email = purrr::map(data, compose_email)
    )


purrr::map2(
  .x = dat$draft_email,
  .y = here::here("drafts", dat$draft_name),
  .f = write_lines
)


write_lines(
  x = dat$draft_email[1],
  file = here::here("drafts", dat$draft_name[1])
)
