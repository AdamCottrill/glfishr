#' Get SC121 - Angler Interviews from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC121 records. SC121
#' records contain information about interviews with anglers conducted
#' during a creel survey.  The SC121 records contain information like
#' the number of anglers in there party, when the started fishing and
#' often answers to creel specific optional questions. This function
#' takes an optional filter list which can be used to return record
#' based on several attributes of the interview.
#'
#' Use \code{show_filters("sc121")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc121" for additional information.
#'
#' @param filter_list list
#'
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
#' sc121 <- get_SC121(list(lake = "HU", year = 2009))
#'
#' sc121 <- get_SC121(list(lake = "HU", prj_cd__like = "_001", year = 2009))
#' sc121 <- get_SC121(list(lake = "HU", prj_cd__like = "_001", year = 2009), show_id = TRUE)
get_SC121 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc121", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc121/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
