
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
    glue("If you are ready to sign up, here is the process:") %>% 
    glue("1. Please review our current schedule of curators (https://tinyurl.com/wearerladies-schedule) and identify a first and second choice open week you would like to curate.\n\n") %>% 
    glue("2. Submit the sign up form (https://tinyurl.com/wearerladies-sign-up), which takes approximately 20 minutes to complete. You submit your desired weeks in this form.\n\n") %>%
    glue("3. Email WeAre@rladies.org with a photo of yourself for the curator graphic.\n\n") %>% 
    glue("4. Once we have your sign up form and your photo, a member of the RoCur team will email you to confirm your scheduled week and provide you more information about curating.\n\n") %>% 
    glue("\n\n") %>% 
    glue("\n\n") %>% 
    glue("If you are interested in curating, but not immediately, please consider this an open invitation to schedule yourself when your time allows.\n\n") %>% 
    glue("\n\n") %>% 
    glue("Thank you for considering curating for @WeAreRLadies!") %>% 
    glue("\n\n") %>%
    glue("\n\n") %>% 
    glue("The RoCur Team\n\n") %>% 
    glue("Katherine Simeon, Emmanuelle Nunes, & Shannon Pileggi")
}
