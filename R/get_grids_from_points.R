#' Get 5-minute grids from an array of points
#'
#' This function accesses the api endpoint that accepts an array of
#' points and returns the unique identifier of the associated 5-minute
#' grids. The request_body argument must be a data-frame with the
#' columns 'slug', 'dd_lat', and 'dd_lon'. All three fields must be
#' populated. If the request is successful, the function will return
#' an data-frame with the fields 'slug', 'dd_lat', 'dd_lon' and
#' 'grid5_slug'. grid5_slug will identify the grid that the point
#' defined by dd_lat and dd_lon is contained within. If the
#' coordinates are outside the bounds of any known grid, the
#' grid5_slug value will be NA.
#'
#'
#' See https://intra.glis.mnr.gov.on.ca/common/grid5s/
#' for the full list of 5-minute grids
#'
#'
#' @param request_body dataframe with the fields 'slug', 'dd_lat', 'dd_lon'
#'
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#'
#' points <- data.frame(
#'   slug = c("point-A", "point-B", "point-C"),
#'   dd_lat = c(45.0, 43.5, 45.5),
#'   dd_lon = c(-81.4, -81.8, -81.0)
#' )
#'
#' grid5s <- get_grid5s_from_points(points)
get_grid5s_from_points <- function(request_body, to_upper = FALSE) {
  common_api_url <- get_common_portal_root()

  # NOTE: POST urls *MUST* end with a slash
  my_url <- sprintf(
    "%s/spatial_lookup/grid5s/",
    common_api_url
  )
  payload <- api_to_dataframe(my_url, recursive = FALSE, request_body = request_body, request_type = "POST")
  payload <- prepare_payload(payload, show_id = TRUE, to_upper = to_upper)

  return(payload)
}
