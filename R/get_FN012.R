#' Get FN012 - Sampling specs (species and group) from FN_Portal API
#'
#' This function accesses the api endpoint for FN012 records.
#' FN012 records contain a list of anticipated species for a project and the
#' likely length and weight ranges for those species. These constraints are used
#' by ProcVal to check that biodata for fish caught during the project is
#' reasonable. The FN012 records contain information like minimum and maximum
#' TLEN, FLEN, RWT, and K values for each species. This function takes an
#' optional filter list which can be used to return records based on several
#' attributes of the project such as protocol, lake, project code, and species.
#'
#' See
#' http://10.167.37.157/fn_portal/api/v1/redoc/#operation/fn_012_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn012 <- get_FN012(list(lake = "HU"))
#'
#' filters <- list(lake = "HU", prj_cd = c("LHA_IA21_823", "LHA_IA20_812"))
#' fn012 <- get_FN012(filters)
get_FN012 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn012", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn012/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
