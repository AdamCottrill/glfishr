#' Get SC111 - Creel Interview Logs from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC111 records.  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the creel such as project
#' code, or part of the project code, lake, first year, last year,
#' contact, or any of the strata
#'
#' Use \code{show_filters("sc111")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc111" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc111 <- get_SC111(list(lake = "ON", year = 2012))
#'
#' sc111 <- get_SC111(list(prj_cd = "LHA_SC08_120"))
#'
#' sc111 <- get_SC111(list(prj_cd = "LHA_SC08_120"), show_id = TRUE)
get_SC111 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc111", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc111/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
