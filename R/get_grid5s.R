#' Get 5-minute grids - A list of 5-minute grids for the Great Lakes
#'
#' This function accesses the api endpoint for 5-minute grids and returns
#' their number and the corresponding lake. It can fetch the entire table,
#' or it accepts a filter parameter for lake. The filter parameters 'page'
#' and 'page_size' are also accepted. No other filter
#' parameters are currently available for this endpoint.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/grid5s/
#' for the full list of 5-minute grids
#'
#'
#' @param filter_list list
#'
#' @param show_id include the fields the 'id' and 'slug' in the
#' returned data frame
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' grid5s <- get_grid5s(list(page_size = 5000))
#' erie_grid5s <- get_grid5s(list(lake = "ER"))
#' grid5_slugs <- get_grid5s(list(page_size = 5000), show_id = TRUE)
get_grid5s <- function(
    filter_list = list(),
    show_id = FALSE,
    to_upper = TRUE,
    record_count = FALSE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  check_filters("grid5s", filter_list, "common")

  my_url <- sprintf(
    "%s/grid5s/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
