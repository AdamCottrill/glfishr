#' Get Species list data from Common API
#'
#' This function accesses the api endpoint to for Species list
#' available in Common. Only the fields spc, spc_nmco, spc_nmsc
#' and species_at_risk are returned unless detail=TRUE is specified
#' in the filter_list. The optional filter list can be used to return
#' species based on part of their common or scientific name.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/species_list_list
#' for the full list of available filter keys (query parameters)
#' 
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
#' trout <- get_species(list(spc_nmco__like = "trout"))
#' goby <- get_species(list(spc=366, detail=TRUE))
get_species <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  check_filters("species", filter_list, "common")
  # TODO: fix detail = TRUE warning
  my_url <- sprintf(
    "%s/species/%s",
    get_common_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
