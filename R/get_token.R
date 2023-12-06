#' Get GLIS API token
#'
#' A helper function to fetch a token from the GLIS API. The token is
#' added to the GET request header. A new token is needed every 24 hours
#' (or when the existing token is cleared from the Global Environment).
#'
#' @return string
#' @export

get_token <- function() {
  body <- get_credentials()
  domain <- get_domain()

  r <- httr::POST(sprintf("%sapi-auth/token/", domain), body = body)
  token <- httr::content(r)

  if (is.null(token$non_field_errors)) {
    assign("token", token, envir = .GlobalEnv)
    message("You have been successfully authenticated on the GLIS server.")
  } else {
    assign("token", NULL, envir = .GlobalEnv)
    warning(token$non_field_errors)
  }
}
