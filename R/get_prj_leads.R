#' Get project leads - A list of project leads used in GLIS
#'
#' This function accesses the api endpoint for project leads and returns
#' their names and usernames. It can fetch the entire table of active project leads,
#' or it accepts the filter parameters to match all or part of a first name,
#' last name, or username.
#'
#'
#'
#' See
#' http://10.167.37.157/fn_portal/api/v1/redoc/#tag/prj_ldr
#' for a full list of available filter parameters.
#'
#' See
#' http://10.167.37.157/common/project_leads
#' for the full list of current and former staff that can be
#' entered as a project lead.
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' prj_leads <- get_prj_leads()
#' all_prj_leads <- get_prj_leads(list(all = TRUE))
#' all_steves <- get_prj_leads(list(first_name__like = "ste", all = TRUE))
#' prj_lead_slugs <- get_prj_leads(show_id = TRUE)
get_prj_leads <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  check_filters("prj_ldr", filter_list, "fn_portal")

  my_url <- sprintf(
    "%s/prj_ldr/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
