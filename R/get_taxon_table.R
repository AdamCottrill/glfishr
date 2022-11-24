#' Get taxon table - A list of fish and non-fish species and their ITIS taxon code
#'
#' This function accesses the api endpoint for taxon records of fish and 
#' non-fish species. These records include the ITIS code, common name, scientific
#' name, taxonomic rank, vert/invert classification, and HHFAU code (if applicable). 
#' Different taxonomic ranks allow selection of a taxon at different levels of
#' specificity (e.g. 'Turtles/Testudines' vs. 'Eastern painted turtle'). 
#' 
#' Current filter parameters are 'taxon', 'itiscode', 'taxon_name', 'taxon_label',
#' 'taxonomic_rank', 'vertinvert', and 'omnr_provincial_code'.
#' 
#'
#' See
#' http://10.167.37.157/common/taxon
#' for the full list of taxon codes
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
#' taxa_list <- get_taxon_table()
#' order_list <- get_taxon_table(list(taxonomic_rank = "Order"))
get_taxon_table <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  # TODO - add check_filters() when there's a swagger endpoint for common api
  # check_filters("taxon_list", filter_list)
  # TODO - replace with function to get api domain for the common app when it
  # exists
  # TODO - add examples of new filters if/when they exist (e.g. taxon_label__like)
  common_api_url <- "http://10.167.37.157/api/v1/common"
  check_filters("common_filters", filter_list)
  my_url <- sprintf(
    "%s/taxon/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper)

  return(payload)
}
