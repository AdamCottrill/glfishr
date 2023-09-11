#' Get TFAT Tag Reporters
#'
#' This function accesses the TFAT api endpoint to for tag reporters - basic
#' information about entities who have reported tags. Most often these are
#' anglers, the general public, or other agencies.  This api endpoint returns
#' basic information about tag reporters including first and last name,
#' affiliation, and contact information. This api endpoint is only available to
#' authenticated and authorized users.
#'
#' This function takes an optional filter list which can be used to return
#' records based on several attributes of the reporter (first and last name
#' 'like'),  the reporting event (reporting date, reporting method, or follow-up
#' requested), or the tag recovery event such as the species or size of fish or
#' the tag attributes such as colour, placement, or tag type.
#'
#' See http://10.167.37.157/tfat/api/redoc/#angler for the full list of
#' available filter keys (query parameters)
#'
#'
#' @param filter_list list
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#'
#' @export
#'
#'
get_tfat_reporters <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/angler/%s",
    get_tfat_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
