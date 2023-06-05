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

  assign("token", token, envir = .GlobalEnv)

  print(token)
}
