#' Get FN022 - Season Strata Data FN_Portal API
#'
#' This function accesses the api endpoint to for FN022
#' records. FN022 records contain information about the defined season
#' associated with a project.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_022_list
#' for the full list of available filter keys (query parameters)
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
#' fn022 <- get_FN022(list(lake = "ON", year = 2012))
#'
#' fn022 <- get_FN022(list(prj_cd = "LHA_IA19_812"))
#' fn022 <- get_FN022(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_FN022 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn022", filter_list)
  my_url <- sprintf(
    "%s/fn022/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
