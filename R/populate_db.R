##' Populate target database
##'
##' given a list containing our data elements and a target database,
##' iterate over the list and insert the data into the corresponding
##' table in the target database.  The names in the list must
##' correspond with the tables in the target database, and it must be
##' possible to insert the tables in alphabetical order. (which works
##' for FN-2, but may not always be the case)
##'
##' @param target - the path to the target accdb file
##' @param data - a named list containing the data to insert the
##' target db
##' @param verbose - should the table and record count be reported
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return NULL
##' @seealso append_data, populate_template_assessment
populate_db <- function(target, data, verbose) {
  for (tbl in sort(names(data))) {
    append_data(target, tbl, data[[tbl]], verbose)
  }
}
