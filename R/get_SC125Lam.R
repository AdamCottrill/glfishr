#' Get SC125Lam - Lamprey Wound data from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC125 Lamprey
#' records. SC125 Lam records contain information about the individual
#' lamprey wounds observed on a sampled fish.  Historically, lamprey
#' wounds were reported as a single field (XLAM) in the SC125 table.
#' In the early 2000 the Great Lakes fishery community agreed to
#' capture lamprey wounding data in a more consistent fashion the
#' basin, using the conventions described in Ebener et al. 2006.  The
#' SC125Lam table captures data from individual lamprey wounds
#' collected using those conventions.  A sampled fish with no
#' observed wound will have a single record in this table (with
#' lamijc value of 0), while fish with lamprey wounds, will have one
#' record for every observed wound. This function takes an optional
#' filter list which can be used to return records based on several
#' different attributes of the wound (wound type, degree of healing,
#' and wound size) as well as, attributes of the sampled
#' fish such as the species, or group code, or attributes of the
#' interview, or the creel(s) that the samples were collected in.
#'
#' Use ~show_filters("sc125Lamprey")~ to see the full list of available filter
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
#' sc125Lam <- get_SC125Lam(list(lake = "HU", spc = "081", year = 2000))
#'
#'
#' filters <- list(lake = "HU", spc = "076")
#' sc125Lam <- get_SC125Lam(filters)
#' sc125Lam <- get_SC125Lam(filters, show_id = TRUE)
get_SC125Lam <- function(filter_list = list(), show_id = FALSE,
                         to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc125lamprey", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc125lamprey/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
