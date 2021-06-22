##' Get FN125Tags - Tagging data from FN_Portal API
##'
##' This function accesses the api endpoint to for FN125Tags
##' records. FN125Tags records contain information about the
##' individual tags applied to or recovered from on a sampled fish.
##' Historically, tag data was stored in three related fields -
##' TAGDOC, TAGSTAT and TAGID.  This convention is fine as long a
##' single biological sample only has a one tag. In recent years, it
##' has been come increasingly common for fish to have multiple tags,
##' or tag types associated with indiviudal sampling events. FN125Tag
##' accomodates those events.  This function takes an optional filter
##' list which can be used to return records based on several
##' different attributes of the tag (tag type, colour, placement,
##' agency, tag stat, and tag number) as well as, attributes of the
##' sampled fish such as the species, or group code, or attributes of
##' the effort, the sample, or the project(s) that the samples were
##' collected in.
##'
##' See
##' http://10.167.37.157/fn_portal/redoc/#operation/fn_125tags_list
##' for the full list of available filter keys (query parameters)
##'
##' @param filter_list list
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @export
##' @examples
##'
##' fn125Tags <- get_FN125Tags(list(lake='ON', year=2019, spc='081',gear='GL'))
##'
##'
##' fn125Tags <- get_FN125Tags(list(lake='SU'))
##'
##' filters <- list(lake='HU', spc='076', grp='55')
##' fn125Tags <- get_FN125Tags(filters)
##'
get_FN125Tags <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/fn125tags/%s",
    get_fn_portal_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
