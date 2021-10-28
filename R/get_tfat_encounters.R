#' Get TFAT Tag Encounters
#'
#' This function accesses the TFAT api endpoint for tag encounters - sampling
#' events were tags were either applied or re-captured during OMNR field
#' projects. (excluding CWTs). The TFAT encounter information contains all of
#' the information required to analyze  tagging data, but they are not the
#' definitive record for biological samples, and do not contain any information
#' about other fish caught in the same sampling event.  See Project Tracker for
#' more information about tagging projects and FN_Portal(and other master
#' databases) to access the complete dataset.
#'
#' This function takes an optional filter list which can be used to return
#' records based on several attributes of the tagged fish such as species, size,
#' sex, or maturity, the tag attributes such as colour, placement, tag type, or
#' tag status (either tagged or recovered), or attributes of the projects in
#' which the encounters occurred such as lake or year the projects were run.
#'
#' See http://10.167.37.157/tfat/api/redoc/#encounter for the full list of
#' available filter keys (query parameters)
#' #'
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
#' # fish that had tags applied in Lake Huron between 2012 and 2018
#' encounters <- get_tfat_encounters(list(
#'   lake = "HU", year__gte = 2012, year__lte =
#'     2018, tagstat = "A"
#' ))
#'
#' # Fish that were sampled in Lake Superior and had yellow OMNR tag applied,
#' # or had a yellow omnr tag on recapture
#' encounters <- get_tfat_encounters(list(lake = "SU", tagdoc__endswith = "012"))
#'
#' # recovered walleye or musky
#' encounters <- get_tfat_encounters(list(spc = c("334", "132"), tagstat = "C"))
get_tfat_encounters <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/encounter/%s",
    get_tfat_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
