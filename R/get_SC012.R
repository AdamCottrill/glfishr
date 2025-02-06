#' Get SC012 - Sampling specs (species and group) from Creel Portal API
#'
#' This function accesses the api endpoint for SC012 records.  SC012
#' records contain a list of anticipated species for a project and the
#' likely length and weight ranges for those species. These
#' constraints are used by ProcVal to check that biodata for fish
#' caught during the project is reasonable. The SC012 records contain
#' information like minimum and maximum TLEN, FLEN, RWT, and K values
#' for each species. This function takes an optional filter list which
#' can be used to return records based on several attributes of the
#' project such as protocol, lake, project code, and species.
#'
#' Use \code{show_filters("sc012")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc012" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc012 <- get_SC012(list(lake = "HU"))
#'
#' filters <- list(prj_cd = c("LHA_SC17_DR7", "LHA_IA22_100"))
#' fn012 <- get_FN012(filters)
get_SC012 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc012", filter_list, "creels")
  my_url <- sprintf(
    "%s/sc012/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
