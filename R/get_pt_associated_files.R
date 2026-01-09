#' get_pt_associated_files - Project Tracker Associated Files
#'
#' This function accesses the api endpoint for associated files that have
#' been uploaded to project tracker.  This api endpoint accepts a
#' large number of filters associated with the project.
#' Project specific filters include project code(s), years, lakes, and
#' project lead.  Use \code{show_filters("associated_files")} to see the full list
#' of available filters.  This function returns a dataframe containing
#' attributes of the upload files, including project code, and
#' the path to the file on the server. It is often used in
#' conjunction with [fetch_pt_associated_files()] to actually download the
#' selected files to a target directory.
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the returned dataframe be
#'   converted to upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @seealso [fetch_pt_associated_files()]
#' @examples
#' \dontrun{
#' filters <- list(lake = "HU", year__gte = 2012, year__lte = 2018)
#' files <- get_pt_associated_files(filters)
#'
#' filters <- list(lake = "HU", year__gte = 2012, prj_cd__like = "006")
#' files <- get_pt_associated_files(filters)
#'
#' files <- get_pt_associated_files(list(lake = "ER"))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' files <- get_pt_associated_files(filters)
#'
#' files <- get_pt_associated_files(list(lake = "HU"))
#' }
#'
get_pt_associated_files <- function(
    filter_list = list(),
    to_upper = TRUE,
    record_count = FALSE,
    add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("associated_files", filter_list, api_app = "project_tracker")
  my_url <- sprintf(
    "%s/associated_files/%s",
    get_pt_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(
    my_url,
    recursive = recursive,
    record_count = record_count
  )
  payload <- prepare_payload(
    payload,
    to_upper = to_upper,
    add_year_col = add_year_col
  )

  return(payload)
}
