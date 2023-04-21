#' Get GLIS Credentials
#' 
#' A helper function to prompt a user for their GLIS username and password.
#' Using rstudioapi creates a pop-up to enter credentials so that usernames
#' and passwords are not saved, and passwords are not visible.

get_credentials <- function(){
  username <- rstudioapi::showPrompt(title = "Username", message = "Please enter your GLIS username (email):")
  password <- rstudioapi::askForPassword(prompt = "Please enter your GLIS password:")
  return(list(username=username, password=password))
}