#' Perform transformations to api payload before return data frame
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
#' @param ... additional arguments that are passed to merge. Normally
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
#' fn123 <- join_fn_fields(fn121, fn123, c("SIDEP0"), all.x = TRUE)
#'
#' # add gear to the FN121 table:
#' fn028 <- get_FN028(list(prj_cd = prj_cd))
#' fn121 <- join_fn_fields(fn028, fn121, c("GR"))
#' # then add gear and site depth to each catch count record:
#' fn123 <- join_fn_fields(fn121, fn123, c("GR"))
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
  # our parent records, we need to stop - otherwise we end up with a
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



#' Pluck a data-frame from a named list of key-value pairs
#'
#' This is a helper function that is used to extract or pluck a
#' data-frame from a named list of key-values pairs.  Api endpoints
#' for lookup-values are often in the form of key-value pairs. This
#' function selects the named element from list and returns it as a
#' data-frame with the columns 'value' and 'label'. This function is
#' not expected to be called directly, but is used by other
#' convenience functions (\code{get_tag_colours()},
#' \code{get_tag_types()}).
#'
#' @param payload list
#'
#' @param what string
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#'
#'
pluck_dataframe <- function(payload, what = "tag_type") {
  df <- data.frame(payload[what])
  names(df) <- c("value", "label")
  return(df)
}


#' Uncount Tallies
#'
#' This function "uncounts" a tally, duplicating each row a number of times
#' equal to the value in the selected tally column. It is a simplified version
#' of the tidyr function uncount().
#'
#' @param df FN124 table fetched from GLIS using get_FN124()
#' @param tally_col Column name where the tally is stored; enter as a string
#'
#' @return dataframe
#' @export
#'
#' @examples
#' LOA_IA21_TW1 <- get_FN124(list(prj_cd = "LOA_IA21_TW1"))
#' LOA_IA21_TW1_long <- uncount_tally(LOA_IA21_TW1, "SIZCNT")
uncount_tally <- function(df, tally_col) {
  long_df <- df[rep(seq(nrow(df)), df[[tally_col]]), names(df) != tally_col]

  rownames(long_df) <- NULL

  return(long_df)
}




##' Truncate the last element from glis slug
##'
##' Slug are used thorughout glis to uniquely identify individual
##' records.  Slugs are aways build a contenated string of key fields,
##' converted to lowercase and separated by dashes.  This function can
##' be used to create the slug of an objects parent by lopping off the
##' termal entity and dash.  It can be called recursively to obtian
##' slugs of grandparent or great-grandparent records if necessary.
##' @title Truncate Slug
##' @param slug - a string Often a human readable, unique idnetifier
##' @param levels - a number, defaults to 1. It value indicated the
##'   number of slug components (dash and string elements) to remove
##'   from the input
##' @return string
##' @author R. Adam Cottrill
truncate_slug <- function(slug, levels=1) {
  regex <- sprintf("\\-[0-9a-z]{%d}$", levels)
  x <- gsub(regex, "", slug)
  return(x)
}


##' Get FN121.SAM slug
##'
##' This function accepts a slug and returns a string that corresponds
##' to the net-set slug.  Joining records to the FN121 table is so
##' common, that a designated function is warrented, rather than
##' recursively calling trim_slug() or manually pasting prj_cd and sam
##' together.  The regular expression takes any slug and returns the
##' part of that string that corresponds to the project code and
##' sample number.
##'
##' @title Get FN121 Sam Slug
##' @param slug - string.  Often a human readable, unique idnetifier
##' @return string
##' @author R. Adam Cottrill
sam_slug <- function(slug) {
  fn121_slug <- gsub("^([a-z0-9_]{12}-[a-z0-9]+)-.*", "\\1", slug)
  return(fn121_slug)
}
