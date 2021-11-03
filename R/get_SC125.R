#' Get SC125 - Biological data from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC125
#' records. SC125 records contain the biological data collected from
#' individual fish sampled in creel surveys such as length,
#' weight, sex, and maturity.  This function takes an optional
#' filter list which can be used to return records based on several
#' different biological attributes (such as size, sex, or maturity),
#' but also of the species, or group code, or attributes of
#' the effort, the sample, or the project(s) that the
#' samples were collected in.
#'
#' Use ~show_filters("sc125")~ to see the full list of available filter
#' keys (query parameters)
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
#' sc125 <- get_SC125(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc_in = c("331", "334"),
#'   sidep__lte = 20
#' )
#' sc125 <- get_SC125(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' sc125 <- get_SC125(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' sc125 <- get_SC125(filters)
#'
#' sc125 <- get_SC125(list(prj_cd = "LHA_IA19_812"))
#' sc125 <- get_SC125(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_SC125 <- function(filter_list = list(), show_id = FALSE, to_upper=TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  check_filters("sc125", filter_list)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/sc125/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
