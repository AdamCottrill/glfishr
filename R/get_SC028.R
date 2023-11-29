#' Get SC028 - Fishing Modes from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC028 records. SC028
#' records contain information about the fishing modes included in a
#' creel survey.  Fishing mode typically describes the gear, or method
#' of fishing.
#'
#' Use \code{show_filters("sc028")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc028" for additional information.
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
#' sc028 <- get_SC028(list(lake = "ON", year = 2012))
#'
#' sc028 <- get_SC028(list(prj_cd = "LOA_SC12_002"))
#' sc028 <- get_SC028(list(prj_cd = "LOA_SC12_002"), show_id = TRUE)
get_SC028 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc028", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc028/%s",
    get_sc_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
