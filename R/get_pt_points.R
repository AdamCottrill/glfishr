#' get_pt_points - Project Tracker Points
#'
#' This function accesses the api endpoint to for sampling points that
#' have been uploaded into project tracker.  This api endpoint accepts
#' a large number of filters associated with the project including
#' spatial filters for buffered point, or region of interest.  Project
#' specific filters include project code(s), years, lakes, and project
#' lead.  Use 'show_filter("points")' to see the full list of
#' available filters.  This function returns a data frame containing
#' attributes of project including project code, project project type,
#' dd_lat and dd_lon.
#'
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the returned dataframe be
#'   converted to upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' points <- get_pt_points(list(
#'   lake = "ON", year__gte = 2012,
#'   year__lte = 2018
#' ))
#'
#' points <- get_pt_points(list(
#'   lake = "HU", year__gte = 2012,
#'   prj_cd__like = "006"
#' ))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' points <- get_pt_points(filters)
get_pt_points <- function(filter_list = list(), to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sample_points", filter_list, api_app = "project_tracker/api")
  my_url <- sprintf(
    "%s/sample_points/%s",
    get_pt_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, to_upper = to_upper)

  return(payload)
}
