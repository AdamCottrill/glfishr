#' Get FLEN~TLEn regression coefficients  GLIS API
#'
#' This function accesses the api endpoint in the Great Lakes
#' Information System that returns the species specific regression
#' coefficients to estimate Total Length from Fork Length.
#'
#' This function uses the same filters as the species list, so you can
#' use show_filters('species_list') to see available filters.
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
#' flen2tlen <- get_flen2tlen()
#' flen2tlen <- get_flen2tlen(list(spc_nmco__like = "trout"))
get_flen2tlen <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)

  check_filters("species_list", filter_list, "common")
  common_api_url <- get_common_portal_root()
  my_url <- sprintf(
    "%s/flen2tlen/%s",
    common_api_url,
    query_string
  )

  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
