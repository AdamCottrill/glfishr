#' get_pt_abstracts - Project Tracker Abstracts
#'
#' @description This function accesses the api endpoint to for Project Tracker's abstract
#' records. Project tracker abstract records contain the custom text uploaded 
#' by the project lead of an OMNR netting project.  The abstracts contain a 
#' plain language summary of the project.  This api endpoint accepts a large number of filters
#' associated with the project including spatial filters for buffered
#' point, or region of interest.  Project specific filters include
#' project code(s), years, lakes, and project lead.  Use
#' 'show_filters("projects")' to see the full list of available
#' filters.  This function returns a dataframe containing attributes
#' of project including project code, project name, start and end
#' date, and project lead.
#'
#'
#' @param filter_list list
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @seealso \code{\link{show_filters}}
#' @examples
#' abstract <- get_pt_abstract(list(prj_cd = "LOA_IA17_GL1"))
#' 

get_pt_abstract <- function(filter_list = list(), show_id = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  #check_filters("fn011", filter_list)
  my_url <- sprintf(
    "%s/project_abstracts/%s",
    get_pt_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  
  # if (show_id == FALSE & !is.null(dim(payload))) {
  #   payload <- subset(payload, select = -c(id, slug))
  # }
  return(payload$abstract)
}