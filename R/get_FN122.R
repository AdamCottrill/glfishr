#' Get FN122 - Effort data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN122
#' records. FN122 records contain information about efforts within a
#' sample.  For most gill netting project an effort corresponds to a
#' single panel of a particular mesh size within a net set
#' (gang). For Trap netting and trawling projects, there is usually
#' just a single effort. The FN122 table contains information about
#' that particular effort such as gear depth, gear temperature at set
#' and lift, and effort distance.  This function takes an optional
#' filter list which can be used to return records based on several
#' attributes of the effort including effort distance and depth but
#' also attributes of the projects or nets set they are associated
#' with such project code, lake, first year, last year, protocol,
#' gear etc.
#'
#' Use ~show_filters("fn122")~ to see the full list of available filter
#' keys (query parameters). Refer to https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/
#' and filter by "fn122" for additional information.
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
#' fn122 <- get_FN122(list(
#'   lake = "ON", year = 2012, gr = "GL",
#'   sidep__lte = 15
#' ))
#' fn122 <- get_FN122(list(
#'   lake = "ER", protocol = "TWL",
#'   year__gte = 2010, sidep0__lte = 20
#' ))
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051"
#' )
#' fn122 <- get_FN122(filters)
#' filters <- list(lake = "HU", prj_cd__like = "_006", eff = c("127", "140"))
#' fn122 <- get_FN122(filters)
#'
#' fn122 <- get_FN122(list(prj_cd = "LHA_IA19_812"))
#' fn122 <- get_FN122(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_FN122 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn122", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn122/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
