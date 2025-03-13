#' Get SC022 - Season Strata Data from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC022
#' records. SC022 records contain information about the defined season
#' associated with a creel.
#'
#' Use \code{show_filters("sc022")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc022" for additional information.
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
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc022 <- get_SC022(list(lake = "ON", year = 2012))
#'
#' sc022 <- get_SC022(list(prj_cd = "LHA_SC11_053"))
#' sc022 <- get_SC022(list(prj_cd = "LHA_SC11_053"), show_id = TRUE)
get_SC022 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc022", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc022/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col = add_year_col)

  return(payload)
}
