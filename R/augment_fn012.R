##' Augment the FN012 data
##'
##' the fn012 data downloaded from the api, may be incomplete, missing
##' species and groups that that were actually encountered in the
##' associated  projects. This function adds records to the FN012 table
##' in these instances. If the missing spc-grp combinations can be
##' found in the FN012 protocols table, those values are used,
##' otherwise default values for the species are used instead.    If
##' prune=TRUE SPC-GRP combinations that appear in the FN012 table,
##' but not in the FN123 table, are dropped from the FN012 before it
##' is returned.
##' @param fn011 - dataframe contains fn011 data
##' @param fn012 - dataframe contains fn012 data fetched from the api
##' for given filters
##' @param fn123 - dataframe contains fn123 data fetched from the api
##' for given filters
##' @param prune_fn012 - boolean - should unused FN012 records be
##'   removed from the table?
##' @param source - string. Either "assessment" or "creel"
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012
augment_fn012 <- function(fn011, fn012, fn123, prune_fn012, source) {
  if (source == "assessment") {
    fn011_flds <- c("PRJ_CD", "LAKE", "PROTOCOL")
    extra_fn012_flds <- c("LAKE", "PROTOCOL")
    fetch_012_protocol <- function(protocols) {
      fetch_fn012_protocol_data(protocols)
    }
  } else {
    fn011_flds <- c("PRJ_CD", "LAKE")
    extra_fn012_flds <- c("LAKE")
    fetch_012_protocol <- function(protocols) {
      fetch_sc012_protocol_data(protocols)
    }
  }


  # get the default FN012 prtocol values for all of the projects
  # included in the FN011 - returns default values with PRJ_CD field
  project_protocols <- fn011[, names(fn011) %in% fn011_flds]
  fn012_defaults <- fetch_012_protocol(project_protocols)
  fn012_defaults$key <- with(fn012_defaults, paste(PRJ_CD, SPC, GRP, sep = "-"))

  # check the dimensions of the FN012:
  # if it is empty use the default values we just got
  if (is.null(dim(fn012))) {
    fn012 <- fn012_defaults
    fn012 <- fn012[, !names(fn012) %in% extra_fn012_flds]
  }

  # check the entries in fn012 table with those in the fn123
  # if there are any missing values, add them from the defaults

  # if FN012 is empty we need everything in FN123, otherwise just the
  # missing values
  in_fn012 <- with(fn012, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
  if (is.null(dim(fn123))) {
    need <- c()
  } else {
    in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    need <- setdiff(in_fn123, in_fn012)
  }

  if (!is.null(dim(need))) {
    fn012 <- rbind(
      fn012,
      fn012_defaults[
        fn012_defaults$key %in% need,
        !names(fn012_defaults) %in% append(extra_fn012_flds, "key")
      ]
    )
  }
  # if there are still missing values get them from the SPC table -
  # leaving the sampling fields empty.
  fn012 <- add_missing_fn012(fn012, fn123)

  # prune the fn012 to just the spc-grp sampled if prune TRUE
  if (prune_fn012) {
    fn012 <- prune_unused_fn012(fn012, fn123)
  }

  fn012 <- fn012[order(fn012$PRJ_CD, fn012$SPC, fn012$GRP), ]

  return(fn012)
}
