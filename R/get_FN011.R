#' Get FN011 - Project meta data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN011
#' records. FN011 records contain the hi-level meta data about an
#' OMNR netting project.  The FN011 records contain information like
#' project code, project name, projet leader, start and end date,
#' protocol, and the lake where the project was conducted.  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the project such as
#' project code, or part of the project code, lake, first year, last
#' year, protocol, etc.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_011_list
#' for the full list of available filter keys (query parameters)
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
#' fn011 <- get_FN011(list(lake = "ON", year__gte = 2012, year__lte = 2018))
#'
#' fn011 <- get_FN011(list(lake = "ER", protocol = "TWL"))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' fn011 <- get_FN011(filters)
#'
#' fn011 <- get_FN011(list(lake = "HU", prj_cd__like = "_006"))
#'
#' fn011 <- get_FN011(list(lake = "HU", protocol = "USA"))
#' fn011 <- get_FN011(list(lake = "HU", protocol = "USA"), show_id =
#' TRUE)
#'
get_FN011 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn011", filter_list)
  my_url <- sprintf(
    "%s/fn011/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
