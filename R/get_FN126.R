#' Get FN126 - Diet data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN126
#' records. FN126 records contain the counts of identifiable items in
#' found in the stomachs of sampled fish.  This function takes an
#' optional filter list which can be used to return records based on
#' several different attributes of the diet item (taxon, taxon_like),
#' as well as, attributes of the sampled fish such as the species, or
#' group code, or attributes of the effort, the sample, or the
#' project(s) that the samples were collected in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_126_list
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
#' fn126 <- get_FN126(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc = c("331", "334"),
#'   sidep__lte = 20
#' )
#' fn126 <- get_FN126(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' fn126 <- get_FN126(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn126 <- get_FN126(filters)
#' fn126 <- get_FN126(filters, show_id = TRUE)
get_FN126 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn126", filter_list)
  my_url <- sprintf(
    "%s/fn126/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
