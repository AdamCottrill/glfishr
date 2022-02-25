#' Preform transformations to api payload before return data frame
#'
#'
#' The function join_fn_fields() takes a parent data frame, a child
#' data frame, and a list of fields that you would like get from the
#' parent and add to each record in the child table. The example below
#' adds site depth to each catch count record The '...' is passed
#' through to merge() and to specify left (all.x=TRUE) and right
#' (all.y=T) outer joins to ensure that unmatched records are included
#' in the returned data frame. Child and parent tables don't have to
#' be data frames returned directly from the api - they can be from
#' anywhere, as long as they have the FN-2 key fields.'
#'
#' TODO -> verify that common keys uniquely identify one parent record.
#'
#' @param parent the dataframe that contains the fields we would like
#' to add out our target (child) dataframe.
#' @param child The dataframe that contains the data we are appending
#' columns to.
#' @param parent_fields a vector of field names from the parent data frame
#' that will be added to the child dataframe.
#' @param ... additional arguements that are passed to merge. Normally
#' all.x=TRUE or all.y=TRUE
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#'
#' @examples
#' prj_cd <- "LHA_IA10_006"
#' fn121 <- get_FN121(list(prj_cd = prj_cd))
#' fn123 <- get_FN123(list(prj_cd = prj_cd, spc = "091"))
#'
#' # add site depth to each catch count record:
#' fn123 <- join_fn_fields(fn121, fn123, c("SIDEP"), all.x = TRUE)
#'
#' # add gear to the FN121 table:
#' fn028 <- get_FN028(list(prj_cd = prj_cd))
#' fn121 <- join_fn_fields(fn028, fn121, c("GEAR"))
#' # then add gear and site depth to each catch count record:
#' fn123 <- join_fn_fields(fn121, fn123, c("GEAR"))
join_fn_fields <- function(parent, child, parent_fields, ...) {
  fn_keys <- c(
    "prj_cd", "ssn", "space", "mode", "sama", "sam", "eff", "spc",
    "grp", "fish", "dtp", "prd"
  )

  fn_keys <- c(fn_keys, toupper(fn_keys))

  child_keys <- names(child)[names(child) %in% fn_keys]
  parent_keys <- names(parent)[names(parent) %in% fn_keys]

  common_keys <- intersect(child_keys, parent_keys)
  # check_parent_keys() - if the common keys don't uniquely identify
  # our parent records, we need to stop - otherwize we end up with a
  # cartesian product.
  check_common_keys <- function(parent_data, flds) {
    tmp <- stats::aggregate(subset(parent_data, select = flds),
      by = subset(parent_data, select = flds),
      FUN = length
    )
    return(nrow(tmp) == nrow(parent_data))
  }

  if (!check_common_keys(parent, common_keys)) {
    stop(paste0(
      "Shared key fields do not uniquely identify parent records. /n",
      "You may need to add fields through an intermediate table first."
    ))
  }

  if (!missing(parent_fields)) {
    parent <- subset(parent, select = append(common_keys, parent_fields))
  }

  merged <- merge(parent, child, by = common_keys, ...)

  return(merged)
}
