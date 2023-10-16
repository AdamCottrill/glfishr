#' Get FN121_GPS - GPS data from FN_Portal API
#'
#' This function accesses the api endpoint for FN121_GPS_Tracks
#' records. FN121_GPS_Tracks records contain GPS tracks for projects
#' where GPS data is recorded (e.g. trawls, electrofishing, etc.), including
#' the track ID, coordinates in decimal decrees, the timestamp and site depth.
#' Other relevant details for each SAM are found in the FN121 table.
#' This function takes an optional filter list which can be used to
#' return records based on attributes of the SAM including site depth, timestamp,
#' start and end date and time, effort duration, gear, site depth and location
#' as well as attributes of the projects they are associated with such project
#' code, or part of the project code, lake, first year, last year,
#' protocol, etc.
#'
#' Use ~show_filters("fn121_gps_tracks")~ to see the full list of available filter
#' keys (query parameters). Refer to https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/
#' and filter by "fn121_gps_tracks" for additional information.
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
#' # TODO: Update with relevant examples when more data exists in the portal
#'
#' fn121_gps <- get_FN121_GPS_Tracks(list(lake = "HU", prj_cd__like = "_306"))
#' fn121_gps <- get_FN121_GPS_Tracks(list(lake = "HU", prj_cd__like = "_306"), show_id = TRUE)
get_FN121_GPS_Tracks <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121_gps_tracks", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn121_gps_tracks/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
