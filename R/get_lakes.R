#' Get lakes - A list of lake names and abbreviations used in GLIS
#'
#' This function accesses the api endpoint for lake names and returns
#' lake names and abbreviations. It is useful for fetching a table of
#' all lakes accepted by GLIS, but it also accepts the filter parameter
#' 'lake' to specify one or more lakes (by abbreviation) to fetch.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/lakes/
#' for the full list of lakes
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' lake_list <- get_lakes()
#' erie <- get_lakes(list(lake = "ER"))
#' upper_lakes <- get_lakes(list(lake = c("HU", "SU")))
get_lakes <- function(
    filter_list = list(),
    to_upper = TRUE,
    record_count = FALSE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  check_filters("lakes", filter_list, "common")
  my_url <- sprintf(
    "%s/lakes/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url, record_count = record_count)
  payload <- prepare_payload(payload, to_upper)

  return(payload)
}
