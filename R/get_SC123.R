#' Get SC123 - Catch Counts  from Creel_Portal API
#'
#' This function accesses the api endpoint to for SC123 records from
#' the SC_Portal. SC123 records contain information about catch counts
#' by species and the target species for each creel interview..  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' or group code but also attributes of the interview or the creel
#' that the catches were made in.
#'
#' Use \code{show_filters("sc123")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc123" for additional information.
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
#' sc123 <- get_SC123(list(lake = "HU", year = 2000, spc = "078"))
#'
#' filters <- list(
#'   lake = "ER",
#'   year = 2010,
#'   spc = c("331", "334")
#' )
#' sc123 <- get_SC123(filters)
#'
#'
#' filters <- list(lake = "HU", spc = "076", sek = TRUE, year = 2009)
#' sc123 <- get_SC123(filters)
#'
#' sc123 <- get_SC123(list(prj_cd = "LHA_SC09_033"))
#' sc123 <- get_SC123(list(prj_cd = "LHA_SC09_033"), show_id = TRUE)
get_SC123 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc123", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc123/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
