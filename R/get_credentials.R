#' Get GLIS Credentials
#'
#' A helper function to prompt a user for their GLIS username and
#' password.  The default function uses the rstudioapi which provides
#' pop-up to enter credentials so that usernames and passwords are not
#' saved, and passwords are not visible.  If the users is not using
#' Rstudio, the default readline interface is used.  Depending on the
#' R client, the password characters may not be obscured when the
#' readlines function is called.

get_credentials <- function() {
  rstudio_login <- function() {
    username <- rstudioapi::showPrompt(
      title = "Username",
      message = "Please enter your GLIS username (email):"
    )
    password <- rstudioapi::askForPassword(
      prompt = "Please enter your GLIS password:"
    )
    return(list(username = username, password = password))
  }

  fallback_login <- function() {
    username <- readline("Please enter your GLIS username (email):")
    password <- readline("Please enter your GLIS password:")
    return(list(username = username, password = password))
  }

  credentials <- tryCatch(
    {
      rstudio_login()
    },
    error = function(e) {
      fallback_login()
    }
  )


  return(credentials)
}
