##' Internal function to return the root url for the FN_Portal api.
##'
##' This funciton is intended to be used by all of the functions that
##' call an api endpoint exposed by fn_portal.  If the api enpoint
##' changes in the future, (ie - the domain name changes or the
##' version changes) we just need to update this value.  Note that the
##' url string does *NOT* include a trailing slash.
##'
##' To use a local version of glfishr api during developement, set the
##' local environment variable to True:
##'
##'     >  Sys.setenv(FN_PORTAL_DEV=TRUE)
##'
##' By default, it is assumed that the api is being served on
##' localhost and port 8000, but these can be changed by setting the
##' environment variables FN_PORTAL_HOST, FN_PORTAL_PORT to the
##' appropriate host and port number.
##'
##'      >  Sys.setenv(FN_PORTAL_HOST='<some-ip-address>')
##'      >  Sys.setenv(FN_PORTAL_PORT=8080)
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return string
##'
get_fn_portal_root <- function() {
  api_url <- "fn_portal/api/v1"

  if (Sys.getenv("FN_PORTAL_DEV") == "") {
    # production
    domain <- "http://10.167.37.157/"
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

  return(paste0(domain, api_url))
}
