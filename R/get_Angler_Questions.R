#' Get Angler Questions from Creel Portal API
#'
#' This function accesses the api endpoint for Angler Questions. Angler 
#' Question records contain the extra questions that were asked during
#' creels. The question number corresponds with the ANGOP# fields in the
#' FN121 table. This function takes an optional filter list which can be 
#' used to return records based on the question text, number, and several 
#' attributes of the project such as project code, or part of the project 
#' code, lake, first year, last year, etc.
#' 
#' Use ~show_filters("angler_questions")~ to see the full list of available filter
#' keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' questions_05_15 <- get_Angler_Questions(list(year__gte = 2005, year__lte = 2015))
#'
#' trout_questions <- get_Angler_Questions(list(question_text__like = "trout"))
#'
#' questions_saugeen <- get_Angler_Questions(list(lake = "HU", prj_cd__like = "DR"))
get_Angler_Questions <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("angler_questions", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/angler_questions/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
