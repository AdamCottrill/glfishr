#' Given a list of filters return a url query string
#'
#' Given a list of filters (key-value pairs), this functions returns
#' a url query string that can be applied to an api
#' endpoint. Multiple list elements are separated by a '&' and list
#' elements with multiple values are returned as comma separated
#' values.
#'
#' @param filters list
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @export
#' @return
#' A formatted string that matches the url search parameters
#' @examples
#' # return "?size=sm"
#' build_query_string(list(size = "sm"))
#' # return "?colour=red,blue"
#' build_query_string(list(colours = c("red", "blue")))
#' # return "?size=sm&colour=red,blue"
#' build_query_string(list(size = "sm", colours = c("red", "blue")))
build_query_string <- function(filters) {
  if (length(filters) == 0) {
    return("")
  } else {
    qs <- paste(
      names(filters),
      sapply(filters, paste, collapse = ","),
      sep = "=",
      collapse = "&"
    )
  }
  return(sprintf("?%s", qs))
}
