#' Get SC026_Subspace - Spatial Strata Data Creel_Portal API
#'
#' This function accesses the api endpoint to for SC026_Subspace
#' records. SC026_Subspace records contain information about the lower
#' level spatial strata associated with a project.
#'
#' Use \code{show_filters("sc026subspace")} to see the full list of
#' available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc026subspace" for additional information.
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
#' sc026_subspace <- get_SC026_Subspace(list(lake = "ON", year = 2012))
#'
#' sc026_subspace <- get_SC026_Subspace(list(prj_cd = "LHA_SC03_220"))
#' sc026_subspace <- get_SC026_Subspace(list(prj_cd = "LHA_SC03_220"), show_id = TRUE)
get_SC026_Subspace <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc026subspace", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc026subspace/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
