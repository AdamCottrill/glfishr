##' Get FN121 - Net set data from FN_Portal API
##'
##' This function accesses the api endpoint to for FN121
##' records. FN121 records contain information about net sets or more
##' generally sampling events in OMNR netting projects.  The FN121
##' record contain information like set and lift date and time, effort
##' duration, gear, site depth and location.  This function takes an
##' optional filter list which can be used to return record based on
##' several attributes of the net set including set and lift date and
##' time, effort duration, gear, site depth and location as well as
##' attributes of the projects they are associated with such project
##' code, or part of the project code, lake, first year, last year,
##' protocol, etc.
##'
##' See
##' http://10.167.37.157/fn_portal/redoc/#operation/fn_121_list
##' for the full list of available filter keys (query parameters)
##'
##' @param filter_list list
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @export
##' @examples
##'
##' fn121 <- get_FN121(list(lake='ON', year=2012))
##' fn121 <- get_FN121(list(lake='ER', protocol='TWL', sidep_lte=20))
##' filters <- list(lake='SU',
##'            prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'))
##' fn121 <- get_FN121(filters)
##' fn121 <- get_FN121(list(lake='HU', prj_cd_like='_006'))
##'
get_FN121 <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn121/%s",
    get_fn_portal_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
