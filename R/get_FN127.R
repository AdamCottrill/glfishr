#' Get FN127 - Diet data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN127 - age
#' estimate/interpretations.  This function takes an optional filter
#' list which can be used to return records based on several
#' different attributes of the age estimate such as the assigned age,
#' the aging structure, confidence, number of complete annuli and
#' edge code, or whether or not it was identified as the 'preferred'
#' age for this fish. Additionally, filters can be applied to
#' select age estimates based on attributes of the sampled fish such
#' as the species, or group code, or attributes of the effort, the
#' sample, or the project(s) that the samples were collected in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_127_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn127 <- get_FN127(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc = c("331", "334"),
#'   year = 2010,
#'   sidep__lte = 20
#' )
#' fn127 <- get_FN127(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' fn127 <- get_FN127(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn127 <- get_FN127(filters)
get_FN127 <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn127/%s",
    get_fn_portal_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
