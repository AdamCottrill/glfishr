##' Add FN012 record for missing SPC-GRPs
##'
##' This function adds records to the FN012 table for PRJ_CD-SPC-GRP
##' combinations that exist in the FN123 table (they were caught), but
##' are not currently in the FN012 (Sampling Spec) table.  This is a
##' helper function used by \code{\link{populate_fn012}} and is not
##' intended by called directly by users.
##'
##' @param fn012 Dataframe containing FN012 Sampling specs and keys
##'   "PRJ_CD", "SPC", "GRP"
##' @param fn123 Dataframe containing catch count data and keys
##'   "PRJ_CD", "SPC", "GRP"
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012
add_missing_fn012 <- function(fn012, fn123) {
  # finally check to see if there are any additional species not in
  # the fn012 or fn012 protocl tables. Add place holder rows for them:

  # there might not be any catch data yet - if so, just return the
  # fn012 as it was recieved.
  if (is.null(dim(fn123))) {
    return(fn012)
  }

  in_fn012 <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  fn123$key <- with(fn123, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_fn123 <- unique(fn123$key)
  still_missing <- setdiff(in_fn123, in_fn012)
  if (length(still_missing)) {
    keys <- c("PRJ_CD", "SPC", "GRP")
    missing <- unique(fn123[
      fn123$key %in% still_missing,
      names(fn123) %in% keys
    ])
    fn012 <- merge(fn012, missing,
      by = keys,
      all = TRUE
    )
  }


  return(fn012)
}
