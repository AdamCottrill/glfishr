#' get_pt_reports - Project Tracker Reports
#'
#' This function accesses the api endpoint for files associated with core reporting
#' requirements that have been uploaded to project tracker.  This api endpoint
#' accepts a large number of filters associated with the project or
#' report type.  Project specific filters include project code(s),
#' years, lakes, and project lead.  Reports can also be filtered by
#' their associated milestone.  Valid report types are: "Prj Prop",
#' "Prj Prop Pres", "procvallog", "ProjDescPres", "Prj Desc",
#' "Protocol", "Field Report", "Prj Comp Rep", "Prj Comp Pres",
#' "Sum Rep", and "Creel Estimates" and can be passed in as a single
#' string or as character vector of one or more report types. Use
#' \code{show_filters("reports")} to see the full list of available filters.
#' This function returns a data-frame containing attributes of the
#' report, including project code, report type, and the path to the
#' report on the server. It is often used in conjunction with
#' [fetch_pt_reports()] to actually download the selected reports to a
#' target directory.
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the returned dataframe be
#'   converted to upper case?
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
#' @seealso [fetch_pt_reports()]
#' @examples
#'
#'
#' reports <- get_pt_reports(list(
#'   lake = "ON", year__gte = 2017,
#'   year__lte = 2018
#' ))
#'
#' reports <- get_pt_reports(list(
#'   lake = "HU", year__gte = 2018,
#'   prj_cd__like = "006", report_type = "Protocol"
#' ))
#'
#' reports <- get_pt_reports(list(lake = "ER", year__gte = 2018))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' reports <- get_pt_reports(filters)
#'
#' reports <- get_pt_reports(list(lake = "HU", year = 2018))
#'
get_pt_reports <- function(
    filter_list = list(),
    to_upper = TRUE,
    record_count = FALSE,
    add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("reports", filter_list, api_app = "project_tracker")
  my_url <- sprintf(
    "%s/reports/%s",
    get_pt_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(
    my_url,
    recursive = recursive,
    record_count = record_count
  )
  payload <- prepare_payload(
    payload,
    to_upper = to_upper,
    add_year_col = add_year_col
  )

  return(payload)
}
