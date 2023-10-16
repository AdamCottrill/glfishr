#' Get TFAT Tagging Projects
#'
#' This function accesses the TFAT api endpoint for tagging projects - OMNR
#'  field projects that either recaptured or applied at least one fish tag
#'  (excluding CWTs).  The TFAT project endpoint contains only basic information
#'  about a project such as project code, project name, project lead, start and
#'  and date.  For more detailed information about projects, please see Project
#'  Tracker.
#'
#' This function takes an optional filter list which can be used to return
#' records based on several attributes of the projects such as lake or year they
#' were run, attributes of the tagged fish such as species or size, the tag
#' attributes such as colour, placement, tag type, or tag status (either tagged
#' or recovered).
#'
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
#' # projects that applied Lake Huron between 2012 and 2018
#' projects <- get_tfat_projects(list(
#'   lake = "HU", year__gte = 2012, year__lte =
#'     2018, tagstat = "A"
#' ))
#'
#' # projects that recovered at least one tagged walleye or musky
#' projects <- get_tfat_projects(list(spc = c("334", "132"), tagstat = "C"))
get_tfat_projects <- function(filter_list = list()) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  my_url <- sprintf(
    "%s/project/%s",
    get_tfat_root(),
    query_string
  )
  return(api_to_dataframe(my_url, recursive = recursive))
}
