#' Get Species list data from FN_Portal API
#'
#' This function accesses the api endpoint to for Species list
#' available in Fn_portal. The species list does not contain all of the fields
#' in common lookup table, but the fields are limited to spc,
#' spc_nmco, and spc_nmsc.  This
#' function takes an optional filter list which can be used to return
#' species based on part of their common or scientific name.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/species_list_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' species <- get_species()
#' trout <- get_species(list(spc_nmco_like = "trout"))
get_species <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  check_filters("species_list", filter_list)
  my_url <- sprintf(
    "%s/species_list/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
