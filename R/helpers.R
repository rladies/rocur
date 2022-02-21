
compose_email <- function(data) {
  glue("TO: {data$Q8} \n\n") %>% 
    glue("BCC: {data$Q4} \n\n") %>% 
    glue("SUBJECT: Nominated to curate for @WeAreRLadies\n\n") %>%
    glue("\n\n") %>% 
    glue("Dear {data$Q5}, \n\n") %>% 
    glue("\n\n") %>% 
    glue("We are pleased to share that {data$Q3} {data$Q2} has nominated you to curate for @WeAreRLadies (https://twitter.com/WeAreRLadies) on Twitter!\n\n") %>% 
    glue("\n\n") %>% 
    glue("{data$Q3} thinks you would make an excellent curator because: {data$Q10} \n\n" ) %>% 
    glue("\n\n") %>% 
    glue("{data$optional_text}") %>% 
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
