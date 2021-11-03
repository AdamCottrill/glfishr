#' Get SC025 - Exception Dates from Creel_Portal API
#'
#' This function accesses the api endpoint for SC025 records. SC025
#' records identify exception dates - weekdays that should be treated
#' like a weekend.
#'
#' Use ~show_filters("sc025")~ to see the full list of available filter
#' keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc025 <- get_SC025(list(lake = "ON", year = 2012))
#'
#' sc025 <- get_SC025(list(prj_cd = "LOA_SC12_CRS"))
#' sc025 <- get_SC025(list(prj_cd = "LOA_SC12_CRS"), show_id = TRUE)
get_SC025 <- function(filter_list = list(), show_id = FALSE, to_upper=TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc025", filter_list, api_app='creels')
  my_url <- sprintf(
    "%s/sc025/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
