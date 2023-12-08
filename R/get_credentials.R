##' Get GLIS Credentials
##'
##' A helper function to prompt a user for their GLIS username and
##' password, if the global variables GLIS_USER and GLIS_PASSWORD are
##' not found. The default function uses the rstudioapi which provides
##' pop-up to enter credentials so that usernames and passwords are not
##' saved, and passwords are not visible.  If the users is not using
##' Rstudio, the default readline interface is used.  Depending on the
##' R client, the password characters may not be obscured when the
##' readlines function is called.
##'
##' Users can by-pass the prompts by setting up global variable for
##' their account. These values will be used preferentially if they
##' exists.
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return named list
get_credentials <- function() {
  rstudio_login <- function() {
    username <- rstudioapi::showPrompt(
      title = "Username",
      message = "Please enter your GLIS username (email):"
    )
    password <- rstudioapi::askForPassword(
      prompt = "Please enter your *GLIS* password:"
    )
    return(list(username = username, password = password))
  }

  fallback_login <- function() {
    username <- readline("Please enter your GLIS username (email):")
    password <- readline("Please enter your *GLIS* password:")

    return(list(username = username, password = password))
  }

  username <- Sys.getenv("GLIS_USERNAME")
  password <- Sys.getenv("GLIS_PASSWORD")


  if (username == "" || password == "") {
    msg <-
      paste0(
        "Consider defining environment variables 'GLIS_USERNAME' and  ",
        "'GLIS_PASSWORD'\n to automaically authenticate to GLIS.\n"
      )

    message(msg)

    credentials <- tryCatch(
      {
        rstudio_login()
      },
      error = function(e) {
        fallback_login()
      }
    )
  } else {
    credentials <- list(username = username, password = password)
    return(credentials)
  }
}
