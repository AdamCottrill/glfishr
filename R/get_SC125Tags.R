#' Get SC125Tags - Tagging data from SC_Portal API
#'
#' This function accesses the api endpoint to for SC125Tags
#' records. SC125Tags records contain information about the
#' individual tags applied to or recovered from on a sampled fish.
#' Historically, tag data was stored in three related fields -
#' TAGDOC, TAGSTAT and TAGID.  This convention is fine as long a
#' single biological sample only has a one tag. In recent years, it
#' has been come increasingly common for fish to have multiple tags,
#' or tag types associated with individudal sampling events. SC125Tag
#' accommodates those events.  This function takes an optional filter
#' list which can be used to return records based on several
#' different attributes of the tag (tag type, colour, placement,
#' agency, tag stat, and tag number) as well as, attributes of the
#' sampled fish such as the species, or group code, or attributes of
#' the effort, the sample, or the project(s) that the samples were
#' collected in.
#'
#' Use ~show_filters("sc125Tags")~ to see the full list
#' of available filter keys (query parameters)
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
#'#'
#' filters <- list(lake = "HU", spc = "075")
#' sc125Tags <- get_SC125Tags(filters)
#' sc125Tags <- get_SC125Tags(filters, show_id = TRUE)
get_SC125Tags <- function(filter_list = list(), show_id = FALSE,
                          to_upper=TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc125tags", filter_list, api_app="creels")
  my_url <- sprintf(
    "%s/sc125tags/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
