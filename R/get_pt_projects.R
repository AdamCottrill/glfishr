#' get_pt_projects - Project Tracker Projects
#'
#' This function accesses the api endpoint to for projects in project
#' tracker.  This api endpoint accepts a large number of filters
#' associated with the project including spatial filters for buffered
#' point, or region of interest.  Project specific filters include
#' project code(s), years, lakes, and project lead.  Use
#' \code{show_filters("projects")} to see the full list of available
#' filters.  This function returns a dataframe containing attributes
#' of the project including project code, project name, start and end
#' date, and project lead.
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the returned dataframe be
#'   converted to upper case?
#'
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' projects <- get_pt_projects(list(
#'   lake = "ON", year__gte = 2016,
#'   year__lte = 2018
#' ))
#'
#' projects <- get_pt_projects(list(
#'   lake = "HU", year__gte = 2018,
#'   prj_cd__like = "006"
#' ))
#'
#' projects <- get_pt_projects(list(lake = "ER", year__gte = 2018))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' projects <- get_pt_projects(filters)
#'
#' projects <- get_pt_projects(list(lake = "HU", year__gte = 2018))
get_pt_projects <- function(filter_list = list(), to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("projects", filter_list, api_app = "project_tracker")
  my_url <- sprintf(
    "%s/projects/%s",
    get_pt_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, to_upper = to_upper)

  return(payload)
}
