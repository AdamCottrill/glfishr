#' Get FN125_Tags - Tagging data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN125Tags
#' records. FN125Tags records contain information about the
#' individual tags applied to or recovered from on a sampled fish.
#' Historically, tag data was stored in three related fields -
#' TAGDOC, TAGSTAT and TAGID. This convention is fine as long a
#' single biological sample only has a one tag. In recent years, it
#' has been come increasingly common for fish to have multiple tags,
#' or tag types associated with individual sampling events. FN125Tag
#' accommodates those events. This function takes an optional filter
#' list which can be used to return records based on several
#' different attributes of the tag (tag type, colour, placement,
#' agency, tag stat, and tag number) as well as, attributes of the
#' sampled fish such as the species, or group code, or attributes of
#' the effort, the sample, or the project(s) that the samples were
#' collected in.
#'
#' Use \code{show_filters("fn125tags")} to see the full list of
#' available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/} and
#' filter by "fn125tags" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#'   fields are hidden from the data frame. To return these columns as
#'   part of the data frame, use 'show_id = TRUE'.
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
#' fn125_Tags <- get_FN125_Tags(list(
#'   lake = "ON", year = 2019, spc =
#'     "081", grtp = "GL"
#' ))
#'
#'
#' fn125_Tags <- get_FN125_Tags(list(lake = "SU"))
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn125_Tags <- get_FN125_Tags(filters)
#' fn125_Tags <- get_FN125_Tags(filters, show_id = TRUE)
get_FN125_Tags <- function(filter_list = list(), show_id = FALSE,
                           to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn125tags", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn125tags/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
