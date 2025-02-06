#' Get project leads - A list of project leads used in GLIS
#'
#' This function accesses the api endpoint for project leads and returns
#' their names and usernames. It can fetch the entire table of active project leads,
#' or it accepts the filter parameters to match all or part of a first name,
#' last name, or username.
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/api/v1/swagger/
#' and filter by "project_leads" for a full list of available filter parameters.
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/project_leads/
#' for the full list of current and former staff that can be
#' entered as a project lead.
#'
#'
#' @param filter_list list
#'
#' @param show_id include the fields the 'id' and 'slug' in the
#' returned data frame
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' project_leads <- get_project_leads()
#' all_project_leads <- get_project_leads(list(all = TRUE))
#' all_steves <- get_project_leads(list(first_name__like = "ste", all = TRUE))
#' project_lead_slugs <- get_project_leads(show_id = TRUE)
get_project_leads <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  query_string <- build_query_string(filter_list)
  check_filters("prj_ldr", filter_list, "fn_portal")

  my_url <- sprintf(
    "%s/prj_ldr/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
