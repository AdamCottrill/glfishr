##' Get FN125Lam - Lamprey Wound data from FN_Portal API
##'
##' This function accesses the api endpoint to for FN125Lam
##' records. FN125Lam records contain information about the individual
##' lamprey wounds observed on a sampled fish.  Historically, lamprey
##' wounds were reported as a single field (XLAM) in the FN125 table.
##' In the early 2000 the great lakes fishery community agreed to
##' capture lamprey wounding data in a more consistent fashion the
##' basin, using the conventions described in Ebener etal 2006.  The
##' FN125Lam table captures data from individual lamprey wounds
##' collected using those conventions.  A sampled fish with no
##' observed wound will have a single record in this table (with
##' lamijc value of 0), while fish with lamprey wounds, will have one
##' record for every observed wound.    This function takes an optional
##' filter list which can be used to return records based on several
##' different attributes of the wound (wound type, degree of healing,
##' and wound size) as well as, attributes of the sampled
##' fish such as the species, or group code, or attributes of the
##' effort, the sample, or the project(s) that the samples were
##' collected in.
##'
##' See
##' http://http://10.167.37.157/fn_portal/redoc/#operation/fn_125lam_list
##' for the full list of available filter keys (query parameters)
##'
##' @param filter_list list
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @export
##' @examples
##'
##' fn125Lam <- get_FN125Lam(list(lake='ON', spc='081', gear='GL'))
##'
##' fn125Lam <- get_FN125Lam(list(lake='HU', spc='081', year=2012, gear='GL',
##'    lamijc_type=c('A1', 'A2', 'A3')))
##'
##' filters <- list(lake='ER',
##'                 protocol='TWL',
##'                 spc=c('331', '334'),
##'                 year=2010,
##'                 sidep_lte=20)
##' fn125Lam <- get_FN125Lam(filters)
##'
##' filters <- list(lake='SU',
##'            prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
##'            eff='051',
##'            spc='091')
##' fn125Lam <- get_FN125Lam(filters)
##'
##' filters <- list(lake='HU', spc='076', grp='55')
##' fn125Lam <- get_FN125Lam(filters)
##' ##'

get_FN125Lam <- function(filter_list = list()) {
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn125lamprey/%s",
    get_fn_portal_root(),
    query_string
  )
  return(api_to_dataframe(my_url))
}
