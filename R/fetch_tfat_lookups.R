#' Fetch the values from the tfat lookup api endpoint
#'
#' This is a helper function that is used to fetch the lookup values from tfat.
#' Tfat exposes a lookup endpoint that returns a json response that contains
#' key-value pairs for a number of elements associated with fish tagging - tag
#' types, tag colours, tagging agency etc.  This function calls that endpoint
#' and returns the results as a named list - one list for each key-value pair.
#' This function is not intended to be called directly, but is called by other,
#' higher-level convenience functions (~get_tag_colours()~).
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return list
#'
#'
fetch_tfat_lookups <- function() {
  tfat_url <- get_tfat_root()
  url <- sprintf("%s/lookups", tfat_url)
  raw_json <- jsonlite::fromJSON(url)
  return(raw_json)
}
