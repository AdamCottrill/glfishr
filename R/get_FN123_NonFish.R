
#' Get FN123_NonFish - Catch Counts of Non-Fish species from FN_Portal API
#'
#' This function accesses the api endpoint to for FN123_NonFish records from
#' the FN_Portal. FN123_NonFish records contain information about catch
#' counts by non-fish species for each effort in a sample. This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn123nonfish_list
#' for the full list of available filter keys (query parameters)
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
#'
#' fn123_nonfish <- get_FN123_NonFish(list(lake = "ER", year = 2019))
#'
#' fn123_nonfish <- get_FN123_NonFish(list(prj_cd = "LEA_IA19_SHA"), show_id = TRUE)
get_FN123_NonFish <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn123nonfish", filter_list)
  my_url <- sprintf(
    "%s/fn123nonfish/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
