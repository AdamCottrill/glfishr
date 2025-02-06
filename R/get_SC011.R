#' Get SC011 - Creel Project Metadata from Creel Portal API
#'
#' This function accesses the api endpoint for SC011
#' records. SC011 records contain the high-level meta data about
#' OMNR Creels. The SC011 records contain information like
#' project code, project name, project leader, start and end date,
#' contact method, and the lake where the creel was conducted. This
#' function takes an optional filter list which can be used to return
#' records based on several attributes of the project such as
#' project code, or part of the project code, lake, first year, last
#' year, contact, etc.
#'
#' Use \code{show_filters("sc011")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc011" for additional information.
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
#' sc011 <- get_SC011(list(lake = "ON", year__gte = 2012, year__lte = 2018))
#'
#' sc011 <- get_SC011(list(lake = "ER"))
#'
#' sc011 <- get_SC011(list(lake = "HU", prj_cd__like = "_001"))
#'
#' sc011 <- get_SC011(list(lake = "HU", protocol = "USA"), show_id = TRUE)
get_SC011 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc011", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc011/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
