##' Populate the FN012-Sampling Specs Table
##'
##' This function populates the FN012 table for project selected by
##' the provided filters.  Attributes of the FN011, FN123, FN124 and
##' FN125 elements in the data list are used to augment rows and
##' their attributes in instances where those rows don't already
##' exist.  If prune_fn012 is TRUE only records with at least one
##' corresponding record in the FN123 table are returned.
##' @param filters - list of filters used to select projects
##' @param data - the named list data fetched from the api
##' @param prune_fn012 - boolean - should unused FN012 records be
##' removed from the table?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
populate_fn012 <- function(filters, glis_data, prune_fn012) {
  fn012 <- get_FN012(filters)
  fn012 <- augment_fn012(glis_data$FN011, fn012, glis_data$FN123, prune_fn012)
  fn012 <- assign_fn012_sizesam(fn012, glis_data$FN124, glis_data$FN125)
  fn012 <- fill_missing_fn012_limits(fn012)
}
