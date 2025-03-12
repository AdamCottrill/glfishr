#' Get FN121_Trapnet - Trapnet data from FN_Portal API
#'
#' This function accesses the api endpoint for fn121trapnet
#' records. fn121trapnet records contain details typically collected as part
#' of the Ontario NSCIN protocol: bottom type, cover type, vegetation,
#' and the angle, use, and distance offshore of the trap net leader.
#' Other relevant details for each SAM are found in the FN121 table.
#' This function takes an optional filter list which can be used to return records
#' based on attributes of the SAM including site depth, start and end date
#' and time, effort duration, gear, and location as well as attributes of the projects
#' they are associated with such as project code, or part of the project code, lake,
#' first year, last year, protocol, etc. This function can also take filters related to
#' the bottom, cover, and vegetation types, and the angle/length of the leader.
#'
#' Use \code{show_filters("fn121trapnet")} to see the full list of
#' available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn121trapnet" for additional information.
#'
#' @param filter_list list
#'
#' @param with_121 When 'FALSE', the default, only the trapnet fields
#' from the FN121 table are returned. To return the whole FN121 table
#' (excluding limnology, weather, and trawl fields), use 'with_121 = TRUE'.
#'
#' @param show_id When 'FALSE', the default, the 'slug'
#' field is hidden from the data frame. To return this field
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#' @export
#' @examples
#'
#' fn121_trapnet <- get_FN121_Trapnet(list(
#'   protocol = "NSCIN",
#'   bottom_type = "GP", year = 2022
#' ))
#'
#' fn121_trapnet <- get_FN121_Trapnet(list(
#'   protocol = "NSCIN",
#'   bottom_type = "GP", mu_type = "qma"
#' ), with_121 = TRUE)
#'
#' fn121_trapnet <- get_FN121_Trapnet(list(
#'   protocol = "NSCIN",
#'   bottom_type = "GP"
#' ), show_id = TRUE)
#'
get_FN121_Trapnet <- function(filter_list = list(), with_121 = FALSE, show_id = FALSE, to_upper = TRUE,
                              record_count = FALSE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)

  trapnet_filters <- filter_list[names(filter_list) != "mu_type"]

  query_string <- build_query_string(trapnet_filters)
  check_filters("fn121trapnet", trapnet_filters, "fn_portal")
  my_url <- sprintf(
    "%s/fn121trapnet/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  if (with_121 == TRUE) {
    trapnet_filters <- setdiff(names(filter_list), api_filters$fn121$name)
    new_filters <- filter_list[names(filter_list) %in% trapnet_filters == FALSE]

    FN121 <- get_FN121(new_filters)

    payload <- merge(FN121, payload)
  }

  if (add_year_col) payload <- add_year_col(payload)


  return(payload)
}
