#' Get FN013 - Gear Description Data FN_Portal API
#'
#' This function accesses the api endpoint to for FN013
#' records. FN013 records contain information about the defined gear
#' associated with a project.
#'
#' Use \code{show_filters("fn013")} to see the full list of available filter
#' keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn013" for additional information.
#'
#' @param filter_list list
#'
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn013 <- get_FN013(list(lake = "ON", year = 2012))
#'
#' fn013 <- get_FN013(list(prj_cd = "LOA_IA21_054"))
#' fn013 <- get_FN013(list(prj_cd = "L0A_IA21_054"), show_id = TRUE)
get_FN013 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn013", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn013/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col = add_year_col)

  return(payload)
}
