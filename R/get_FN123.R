
#' Get FN123 - Catch Counts from FN_Portal API
#'
#' This function accesses the api endpoint to for FN123 records from
#' the FN_Portal. FN123 records contain information about catch
#' counts by species for each effort in a sample.  For most gill
#' netting projects this corresponds to catches within a single panel
#' of a particular mesh size within a net set (gang). Group (GRP) is
#' occationally included to futher sub-devide the catch into user
#' defined groups that are usually specific to the project.  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_123_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn123 <- get_FN123(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#'
#' filters <- list(
#'   lake = "ER",
#'   protocol = "TWL",
#'   year = 2010,
#'   spc = c("331", "334"),
#'   sidep__lte = 20
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
get_FN123 <- function(filter_list = list(), show_id = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn123", filter_list)
  my_url <- sprintf(
    "%s/fn123/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)

  if (show_id == FALSE & !is.null(dim(payload))) {
    payload <- subset(payload, select = -c(id, slug))
  }
  return(payload)
}
