#' Get SC024 - Period Type Data Creel_Portal API
#'
#' This function accesses the api endpoint for SC024 records. SC024
#' records contain information about the period used in a creel
#' survey. Often the fishing day is split into morning and afternoon,
#' and in some instances the periods change between seasons.
#'
#' Use ~show_filters("sc024")~ to see the full list of available filter
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
#' sc024 <- get_SC024(list(lake = "ON", year = 2012))
#'
#' sc024 <- get_SC024(list(prj_cd = "LOA_SC12_002"))
#' sc024 <- get_SC024(list(prj_cd = "LOA_SC12_002"), show_id = TRUE)
get_SC024 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc024", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc024/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
