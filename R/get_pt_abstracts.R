#' get_pt_abstracts - Project Tracker Abstracts
#'
#' This function accesses the api endpoint for abstracts that have
#' been uploaded to project tracker. This api endpoint
#' accepts a large number of filters associated with the project or
#' report type. Project specific filters include project code(s),
#' years, lakes, and project lead. Use \code{show_filters("project_abstracts")}
#' to see the full list of available filters.
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the returned dataframe be
#'   converted to upper case?
#'
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' abstracts <- get_pt_abstracts(list(
#'   lake = "ON", year__gte = 2012,
#'   year__lte = 2018
#' ))
#'
#' abstracts <- get_pt_abstracts(list(lake = "ER", year__gte = 2018))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' abstracts <- get_pt_abstracts(filters)
#'
#' abstracts <- get_pt_abstracts(list(lake = "HU", year__gte = 2018))
get_pt_abstracts <- function(filter_list = list(), to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("project_abstracts", filter_list, api_app = "project_tracker")
  my_url <- sprintf(
    "%s/project_abstracts/%s",
    get_pt_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, to_upper = to_upper)

  return(payload)
}
