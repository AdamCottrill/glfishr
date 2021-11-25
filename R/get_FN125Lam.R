#' Get FN125Lam - Lamprey Wound data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN125Lam
#' records. FN125Lam records contain information about the individual
#' lamprey wounds observed on a sampled fish.Historically, lamprey
#' wounds were reported as a single field (XLAM) in the FN125 table.
#' In the early 2000 the great lakes fishery community agreed to
#' capture lamprey wounding data in a more consistent fashion the
#' basin, using the conventions described in Ebener et al. 2006.  The
#' FN125Lam table captures data from individual lamprey wounds
#' collected using those conventions.  A sampled fish with no
#' observed wound will have a single record in this table (with
#' lamijc value of 0), while fish with lamprey wounds, will have one
#' record for every observed wound. This function takes an optional
#' filter list which can be used to return records based on several
#' different attributes of the wound (wound type, degree of healing,
#' and wound size) as well as, attributes of the sampled
#' fish such as the species, or group code, or attributes of the
#' effort, the sample, or the project(s) that the samples were
#' collected in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_125lam_list
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
#' fn125Lam <- get_FN125Lam(list(lake = "ON", spc = "081", gear = "GL"))
#'
#' fn125Lam <- get_FN125Lam(list(
#'   lake = "SU", spc = "081", year__gte = 2015,
#'   lamijc_type = c("A1", "A2", "A3")
#' ))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc = c("331", "334"),
#'   year = 2010,
#'   sidep__lte = 20
#' )
#' fn125Lam <- get_FN125Lam(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' fn125Lam <- get_FN125Lam(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn125Lam <- get_FN125Lam(filters)
#' fn125Lam <- get_FN125Lam(filters, show_id = TRUE)
get_FN125Lam <- function(filter_list = list(), show_id = FALSE, to_upper=TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn125lamprey", filter_list)
  my_url <- sprintf(
    "%s/fn125lamprey/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
