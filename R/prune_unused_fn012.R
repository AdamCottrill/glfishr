##' Remove FN012 records without matching FN123 records
##'
##' A helper function used by populate_fn012 to removed any sampling
##' specification s for species-groups that were not encountered in a
##' project.
##' @param fn012
##' @param fn123
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso get_or_augment_fn012
prune_unused_fn012 <- function(fn012, fn123) {
  fn012$key <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_123 <- unique(with(fn123, paste(PRJ_CD, SPC, GRP, sep = "-")))
  return(subset(fn012, fn012$key %in% in_123, select = -key))
}
