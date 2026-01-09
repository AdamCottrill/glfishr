#' Get FN123 - Catch Counts from FN_Portal API
#'
#' This function accesses the api endpoint to for FN123 records from
#' the FN_Portal. FN123 records contain information about catch
#' counts by species for each effort in a sample.  For most gill
#' netting projects this corresponds to catches within a single panel
#' of a particular mesh size within a net set (gang). Group (GRP) is
#' occasionally included to further sub-divide the catch into user
#' defined groups that are usually specific to the project.  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' Use \code{show_filters("fn123")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn123" for additional information.
#'
#' @param filter_list list
#'
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
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
#' @return dataframe
#' @export
#' @examples
#'
#' fn123 <- get_FN123(list(lake = "ON", year = 2012, spc = "334", gr = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   year = 2010,
#'   spc = c("331", "334"),
#'   sidep0__lte = 20
#' )
#' fn123 <- get_FN123(filters)
#'
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
#'   eff = "051",
#'   spc = "091"
#' )
#' fn123 <- get_FN123(filters)
#'
#' filters <- list(lake = "HU", spc = "076", grp = "55")
#' fn123 <- get_FN123(filters)
#'
#' fn123 <- get_FN123(list(prj_cd = "LHA_IA19_812"))
#' fn123 <- get_FN123(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_FN123 <- function(
    filter_list = list(),
    show_id = FALSE,
    to_upper = TRUE,
    record_count = FALSE,
    add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn123", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn123/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(
    my_url,
    recursive = recursive,
    record_count = record_count
  )
  payload <- prepare_payload(
    payload,
    show_id,
    to_upper,
    add_year_col = add_year_col
  )

  return(payload)
}
