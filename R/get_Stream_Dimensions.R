#' Get Stream Dimensions data from FN_Portal API
#'
#' This function accesses the api endpoint for Stream_Dimensions
#' records. Stream_Dimensions records contain information about
#' streams and rivers in which electrofishing transects take place,
#' including the distance from the start of the transect, the distance
#' across the channel, and stream depth, width, and velocity. Other
#' relevant details for the SUBSPACE are found in the FN121 table.
#' This function takes an optional filter list which can be used to
#' return records based on attributes of the project including project
#' code, or part of the project code, lake, first year, last year,
#' protocol, etc.
#'
#' Use \code{show_filters("stream_dimensions")} to see the full list
#' of available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "stream_dimensions" for additional information.
#'
#' @param filter_list list
#'
#' @param show_id When 'FALSE', the default, the 'slug' field is
#'   hidden from the data frame. To return this field as part of the
#'   data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#'   upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'  returned dataframe?  This argument is ignored if the data frame
#'  does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#' \dontrun{
#' show_filters("stream_dimensions")
#' }
#' # TODO: add more examples when more data is uploaded
#' stream <- get_Stream_Dimensions(list(lake = "SU", year = "2015"))
get_Stream_Dimensions <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE,
                                  record_count = FALSE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("stream_dimensions", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/stream_dimensions/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col = add_year_col)

  return(payload)
}
