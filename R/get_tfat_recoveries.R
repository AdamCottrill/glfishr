#' Get TFAT Tag Recoveries
#'
#' This function accesses the TFAT api endpoint to for tag recoveries - tags
#' reported by anglers, the general public, or other agencies.  Tag Recovery
#' events include information about the tag, the tagged fish, and where the
#' recovery occurred.
#'
#' This function takes an optional filter list which can be used to return
#' records based on several attributes of the tagged fish (species, or size),
#' the tag attributes (colour, placement, tag type) or the recovery event (lake
#' or recovery date)
#'
#' See ~get_tag_attr_values()~ to get a list of values that can be use to filter
#' results based on tag attributes such as colour or tag type.
#'
#' @param filter_list list
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
#' recoveries <- get_tfat_recoveries(list(
#'   lake = "HU", year__gte = 2012, year__lte
#'   = 2018
#' ))
#'
#' # yellow or orange tags recovered in Lake Superior
#' recoveries <- get_tfat_recoveries(list(lake = "SU", tag__colour = c("2,5")))
#'
#' # tags recovered from walleye or musky
#' recoveries <- get_tfat_recoveries(list(spc = c("334", "132")))
get_tfat_recoveries <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/recovery/%s",
    get_tfat_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
