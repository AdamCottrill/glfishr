#' get_pt_nr_milestones - Project Tracker Non-report Milestones
#'
#' This function accesses the api endpoint for non-report milestones
#' in project tracker.  This api endpoint accepts a large number of filters
#' associated with the project or milestone type.  Project specific filters
#' include project code(s), years, lakes, and project lead.  Milestones
#' can also be filtered by their name.  Valid milestone types are: "Submitted",
#' "Approved", "Field Work Conducted", "Data Scrubbed", "Aging Complete",
#' "Data Merged", "Sign off", and "Cancelled" and can be passed in as a single
#' string or as charcter vector of one or more milestone types. Use
#' 'show_filters("project_nr_milestones")' to see the full list of available
#' filters. This function returns a dataframe containing attributes of the
#' report, including project code, project name, and the time at which a
#' milestone was completed.
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
#' @seealso [fetch_pt_reports()]
#' @examples
#'
#' milestones <- get_pt_nr_milestones(list(
#'   lake = "ON", year__gte = 2012,
#'   year__lte = 2018
#' ))
#'
#' milestones <- get_pt_nr_milestones(list(
#'   lake = "HU", year__gte = 2012,
#'   prj_cd__like = "006", milestone = "Submitted"
#' ))
#'
#' milestones <- get_pt_nr_milestones(list(lake = "ER"))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' milestones <- get_pt_nr_milestones(filters)
get_pt_nr_milestones <- function(filter_list = list(), to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("project_nr_milestones", filter_list, api_app = "project_tracker")
  my_url <- sprintf(
    "%s/project_nr_milestones/%s",
    get_pt_portal_root(),
    query_string
  )
  
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, to_upper = to_upper)
  
  return(payload)
}
