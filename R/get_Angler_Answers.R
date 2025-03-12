#' Get Angler Answers from Creel Portal API
#'
#' This function accesses the api endpoint for Angler Answers. Angler
#' Answer records contain the multiple choice answers to any extra
#' questions that were asked during creels. Each answer has two parts: the
#' Answer_Number and Answer_Text. The Answer_Number is recorded in the FN121
#' table in the ANGOP# fields, where the digit in the ANGOP# field corresponds
#' with the Question_Number. The Answer_Text is the text that corresponds
#' with the Answer_Number. This function takes an optional filter list which
#' can be used to return records based on the answer number, text, and
#' several attributes of the project such as project code,
#' or part of the project code, lake, first year, last year, etc.
#'
#' Use \code{show_filters("angler_answers")} to see the full list of available filter
#' keys (query parameters). Refer to \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/}
#' and filter by "angler_answers" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' answer_05_15 <- get_Angler_Answers(list(year__gte = 2005, year__lte = 2015))
#'
#' boat_answers <- get_Angler_Answers(list(answer_text__like = "boat"))
#'
#' manitoulin_answers <- get_Angler_Answers(list(lake = "HU", prj_cd__like = "120"))
get_Angler_Answers <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("angler_answers", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/angler_answers/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col = add_year_col)

  return(payload)
}
