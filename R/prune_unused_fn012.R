##' Remove FN012 records without matching FN123 records
##'
##' A helper function used by populate_fn012 to removed any sampling
##' specification s for species-groups that were not encountered in a
##' project.
##' @param fn012 - dataframe with columns PRJ_CD, SPC, and GRP
##' containing sampling specifications
##' @param fn123 - dataframe with columns PRJ_CD, SPC, and GRP
##' containing catch count information.
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso get_or_augment_fn012
prune_unused_fn012 <- function(fn012, fn123) {
  # there might not be any catch data yet - if so, just return the
  # fn012 as it was recieved.
  if (is.null(dim(fn123))) {
    return(fn012)
  }

  fn012$key <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
  extra <- setdiff(fn012$key, in_fn123)

  # fn012 <- subset(fn012, fn012$key %in% in_123, select = -"key"))
  fn012 <- fn012[
    !fn012$key %in% extra,
    names(fn012) != "key"
  ]


  return(fn012)
}
