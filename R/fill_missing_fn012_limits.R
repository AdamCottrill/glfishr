##' Fill missing FN012 size limits
##'
##' The FN012 table has several fields that are used to bound
##' estimates of fish size and flag potential errors.  When new
##' records are added to the FN012 table, these values are null. This
##' function connects to the glis api endpoint and fetches the
##' attributes for the missing species and updates the corresponding
##' fields in the newly created fn012 records.
##'
##' @param fn012 - dataframe containing FN012 sampling spec. data
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012, assign_fn012_sizsam
fill_missing_fn012_limits <- function(fn012) {
  incomplete <- subset(fn012, is.na(fn012$GRP_DES))
  if (nrow(incomplete)) {
    spc_limits <- get_species(list(
      spc = unique(incomplete$SPC),
      detail = TRUE
    ))
    # select the columns that the spc_limits has in common with fn012
    spc_limits <- subset(spc_limits,
      select = names(spc_limits)[names(spc_limits) %in% names(incomplete)]
    )
    # get the columns of fn012 that are not in the spc_limits tables
    # (except for SPC)
    fn012_columns <- subset(incomplete,
      select = c("SPC", names(incomplete)[!names(incomplete) %in%
        names(spc_limits)])
    )
    missing <- merge(fn012_columns, spc_limits, by = "SPC")
    complete <- subset(fn012, !is.na(fn012$GRP_DES))
    fn012 <- rbind(complete, missing)
  }

  return(fn012)
}
