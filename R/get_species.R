#' Get Species list data from Common API
#'
#' This function accesses the api endpoint to for Species list
#' available in Common. Only the fields spc, spc_nmco, spc_nmsc
#' and species_at_risk are returned unless detail=TRUE is specified
#' in the filter_list. The optional filter list can be used to return
#' species based on part of their common or scientific name.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/api/v1/swagger/
#' and filter by "species" for the full list of available filter keys (query parameters)
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/species/
#' for the full list of fish species
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' species <- get_species()
#' trout <- get_species(list(spc_nmco__like = "trout"))
#' goby <- get_species(list(spc = 366, detail = TRUE))
get_species <- function(filter_list = list(), to_upper = TRUE, record_count = FALSE) {
  query_string <- build_query_string(filter_list)
  check_filters("species", filter_list, "common")
  # TODO: fix detail = TRUE warning
  my_url <- sprintf(
    "%s/species/%s",
    get_common_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, record_count = record_count)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
