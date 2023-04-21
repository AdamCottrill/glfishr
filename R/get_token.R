#' Get GLIS API token
#' 
#' A helper function to fetch a token from the GLIS API. The token is
#' added to the GET request header. A new token is needed every 24 hours
#' (or when the existing token is cleared from the Global Environment).
#'
#' @return string

get_token <- function(){
  
  body <- get_credentials()
  
  r <- httr::POST("http://10.167.37.157/api-auth/token/", body = body)
  token <- httr::content(r)
  
  assign("token", token, envir = .GlobalEnv)
  
  print(token)
}
