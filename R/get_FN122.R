##' Get FN122 - Effort data from FN_Portal API
##'
##' This function accesses the api endpoint to for FN122
##' records. FN122 records contain information about efforts within a
##' sample.  For most gill netting project an effort corresponds to a
##' single panel of a particular mesh size within a net set
##' (gang). For Trap netting and trawling projects, there is usually
##' just a single effort. The FN122 table contains information about
##' that particular effort such as gear depth, gear temperature at set
##' and lift, and effort distance.  This function takes an optional
##' filter list which can be used to return records based on several
##' attributes of the effort including effort distance and depth but
##' also attributes of the projects or nets set they are associated
##' with such project code, lake, first year, last year, protocol,
##' gear etc.
##'
##' See
##' http://10.167.37.157/fn_portal/redoc/#operation/fn_122_list
##' for the full list of available filter keys (query parameters)
##'
##' @param filter_list list
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @export
##' @examples
##'
##' fn122 <- get_FN122(list(lake='ON', year=2012, gear="GL"))
##' fn122 <- get_FN122(list(lake='ER', protocol='TWL', sidep_lte=20))
##' filters <- list(lake='SU',
##'            prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN', eff='051'))
##' fn122 <- get_FN122(filters)
##' filters <- list(lake='HU', prj_cd_like='_006', eff_in=c('127','140'))
##' fn122 <- get_FN122(filters)
##'
get_FN122 <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn122/%s",
    get_fn_portal_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive))
}
