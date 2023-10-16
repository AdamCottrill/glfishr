#' Internal func to get the domain great lake portal api's
#'
#' This function is intended to be used by all of the functions that call an
#' api endpoint exposed by the great lakes api endpoints.
#' Each of the apis. are likely to have slightly different urls (tfat/api/v1,
#' fn_portal/api/v1, etc), but a common domain. If the api domain changes in
#' the future, (ie - the domain name changes or the #' version changes) we just
#' need to update the value returned by this function.
#'
#' To use a local version of glfishr api during development, set the
#' local environment variable to True:
#'
#'     >  Sys.setenv(FN_PORTAL_DEV=TRUE)
#'
#' By default, it is assumed that the api is being served on #' localhost and
# port 8000, but these can be changed by setting the #' environment variables
# FN_PORTAL_HOST, FN_PORTAL_PORT to the #' appropriate host and port number.
#'
#'      > Sys.setenv(FN_PORTAL_HOST='<some-ip-address>')
#'      > Sys.setenv(FN_PORTAL_PORT=8080)
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return string
#'
get_domain <- function() {
  glis_domain <- Sys.getenv("GLIS_DOMAIN")

  if(glis_domain != ""){
    return(glis_domain)
  }

  if (Sys.getenv("FN_PORTAL_DEV") == "") {
    # production
    domain <- "https://intra.glis.mnr.gov.on.ca/"
  } else {
    # local development
    if (Sys.getenv("FN_PORTAL_PORT") == "") {
      port <- "8000"
    } else {
      port <- Sys.getenv("FN_PORTAL_PORT")
    }

    if (Sys.getenv("FN_PORTAL_HOST") == "") {
      host <- "127.0.0.1"
    } else {
      host <- Sys.getenv("FN_PORTAL_HOST")
    }
    domain <- sprintf("http://%s:%s/", host, port)
  }

  return(domain)
}
