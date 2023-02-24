#' Get project leads - A list of project leads used in GLIS
#'
#' This function accesses the api endpoint for project leads and returns
#' their names, usernames, email addresses, and whether they're active users
#' (current staff). It can fetch the entire table of active project leads, 
#' or it accepts the filter parameter all=TRUE to return non-active project leads
#' too. No other filter parameters are currently available for this endpoint.
#' 
#' Note that currently only usernames, first and last names are fetched. More staff, 
#' email addresses and active status will be added. 
#' 
#'
#' See
#' http://10.167.37.157/common/project_leads
#' for the full list of project leads
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
#' all_prj_leads <- get_prj_leads(list(all=TRUE))
#' prj_lead_slugs <- get_prj_leads(show_id = TRUE)
get_prj_leads <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_fn_portal_root()
  #check_filters("tissues", filter_list, "common")
  #TODO: add a warning about 'all=TRUE' being the only allowed filter
  
  my_url <- sprintf(
    "%s/prj_ldr/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
