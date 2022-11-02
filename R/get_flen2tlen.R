#' Get FLEN~TLEn regression coeffients  GLIS API
#'
#' This function accesses the api endpoint in the Great Lakes
#' Information System that returns the species specific regression
#' coeffients to estimate Total Length from Fork Legth.
#'
#' This function uses the same filters as teh specis list, so you can
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
  # TODO - create swagger endpoint for common api. luckly this function
  # shares filters with fn_portal  species_list
  check_filters("species_list", filter_list)
  # TOD0 - create function to get api domain for the common app.
  # this is the only function that currently access the common api
  # directly, but won't be for long.
  common_api_url <- "http://10.167.37.157/api/v1/common"
  my_url <- sprintf(
    "%s/flen2tlen/%s",
    common_api_url,
    query_string
  )

  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
