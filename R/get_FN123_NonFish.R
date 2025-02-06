#' Get FN123_NonFish - Catch Counts of Non-Fish species from FN_Portal API
#'
#' This function accesses the api endpoint to for FN123_NonFish records from
#' the FN_Portal. FN123_NonFish records contain information about catch
#' counts by non-fish species for each effort in a sample. This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' Use \code{show_filters("fn123nonfish")} to see the full list of
#' available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn123nonfish" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn123_nonfish <- get_FN123_NonFish(list(lake = "ER", year = 2019))
#'
#' fn123_nonfish <- get_FN123_NonFish(list(prj_cd = "LEA_IA19_SHA"), show_id = TRUE)
get_FN123_NonFish <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn123nonfish", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn123nonfish/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
