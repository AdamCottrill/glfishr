#' Get TFAT Tag Recovery Reports
#'
#' This function accesses the TFAT api endpoint for tag reports - tag reports
#' are anglers, the general public, or other agencies.  A tag report can have
#' one or many associated tags (i.e. tag recoveries).  Every tag recovery has
#' only one tag report. Tag reports include the reporting date and method, and
#' whether or not a follow-up letter  was requested.
#'
#' This function takes an optional filter list which can be used to return
#' records based on several attributes of the reporting event (reporting date,
#' reporting method, or follow-up requested), the tagged fish such as species or
#' size, or the tag attributes such as colour, placement, or tag type.
#'
#'
#' @param filter_list list
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#'
#' @export
#'
#' @examples
#'
#' # tags recovered in Lake Huron between 2012 and 2018
#' reports <- get_tfat_reports(list(
#'   lake = "ON", year__gte = 2012, year__lte =
#'     2018
#' ))
#'
#' # yellow or orange tags recovered in Lake Superior
#' reports <- get_tfat_reports(list(lake = "SU", tag__colour = c("2,5")))
#'
#' # tags recovered from walleye or musky
#' reports <- get_tfat_reports(list(spc = c("334", "132")))
get_tfat_reports <- function(filter_list = list(), record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/report/%s",
    get_tfat_root(),
    query_string
  )

  data <- api_to_dataframe(
    my_url,
    recursive = recursive,
    record_count = record_count
  )

  return(data)
}
