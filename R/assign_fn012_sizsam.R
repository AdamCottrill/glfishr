##' Populate FN012.SIZSAM based
##'
##' This function updates the BIOSAM values in the FN012 table based
##' on the presence of SPC-GRP records in the associated FN124 and
##' FN125.
##'
##' @param fn012 - dataframe containing FN012 sampling spec. data
##' @param fn124 - dataframe containing FN124 length tally data
##' @param fn125 - dataframe containing FN125 biological data
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
##' @seealso fill_missing_fn012_limits, populate_fn012
assign_fn012_sizesam <- function(fn012, fn124, fn125) {
  # make a unique key for proj-spc-grp
  key <- paste(fn012$PRJ_CD, fn012$SPC, fn012$GRP, sep = "_")

  # Assigning SIZSAM
  in_fn124 <- unique(paste(fn124$PRJ_CD, fn124$SPC, fn124$GRP, sep = "_"))
  in_fn125 <- unique(paste(fn125$PRJ_CD, fn125$SPC, fn125$GRP, sep = "_"))

  fn012$SIZSAM <- ifelse((key %in% in_fn124) &
    (key %in% in_fn125), 3,
  ifelse((key %in% in_fn124) & !(key %in% in_fn125), 2,
    ifelse(!(key %in% in_fn124) & (key %in% in_fn125), 1, 0)
  )
  )

  return(fn012)
}
