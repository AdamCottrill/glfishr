#' Get FN125 - Biological data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN125
#' records. FN125 records contain the biological data collected from
#' individual fish sampled in assessment projects such as length,
#' weight, sex, and maturity. For convenience this end point also
#' returns data from child tables such as the 'preferred' age, and
#' lamprey wounds.  This function takes an optional
#' filter list which can be used to return records based on several
#' different biological attributes (such as size, sex, or maturity),
#' but also of the species, or group code, or attributes of
#' the effort, the sample, or the project(s) that the
#' samples were collected in.
#'
#' See
#' http://10.167.37.157/fn_portal/api/v1/redoc/#operation/fn_125_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#'
#' fn125 <- get_FN125(list(lake = "ON", year = 2012, spc = "334", gr = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc_in = c("331", "334"),
#'   sidep__lte = 20
#' )
#' fn125 <- get_FN125(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' fn125 <- get_FN125(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn125 <- get_FN125(filters)
#'
#' fn125 <- get_FN125(list(prj_cd = "LHA_IA19_812"))
#' fn125 <- get_FN125(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_FN125 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  check_filters("fn125", filter_list, "fn_portal")
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn125/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
