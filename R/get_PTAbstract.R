#' Get PT Abstract - Project abstract from FN_Portal API
#'
#' This function accesses the api endpoint to for Project Tracker's abstract
#' records. PT Abstract records contain the custom text uploaded by the project 
#' lead of an OMNR netting project.  The abstracts contain a plain language summary
#' of the project.  This function takes a project code to return the abstract specific to
#' that record.
#'
#'
#' @param prj_cd character
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#' abstract <- get_PTAbstract(list(prj_cd = "LOA_IA17_GL1"))
#' 

get_PTAbstract <- function(filter_list = list(), show_id = FALSE) {
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
