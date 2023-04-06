#' Get SC126 - Diet data from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC126
#' records. SC126 records contain the counts of identifiable items in
#' found in the stomachs of sampled fish.  This function takes an
#' optional filter list which can be used to return records based on
#' several different attributes of the diet item (taxon, taxon_like),
#' as well as, attributes of the sampled fish such as the species, or
#' group code, or attributes of interview, or the
#' creel(s) that the samples were collected in.
#'
#' #' Use ~show_filters("sc126")~ to see the full list of available filter
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
#' sc126 <- get_SC126(list(lake = "HU", year = 2000, spc = "334"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   spc = c("331", "334"),
#'   sidep__lte = 20
#' )
#' sc126 <- get_SC126(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' sc126 <- get_SC126(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' sc126 <- get_SC126(filters)
#' sc126 <- get_SC126(filters, show_id = TRUE)
get_SC126 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc126", filter_list, "creels")
  my_url <- sprintf(
    "%s/sc126/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
