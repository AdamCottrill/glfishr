##' Perform transformations to api payload before return data frame
##'
##' This function takes the data-frame returned from the api call and
##' preforms any required transformations before returning it.
##' Currently the function optionally removes is and slug from the data
##' frame (if they exist), and transforms all of the field names to
##' uppercase so that they match names that have been traditionally
##' used in FISHNET-2.  Other transformations or modifications could be
##' added in the future.
##'
##' @param payload dataframe
##'
##' @param show_id When 'FALSE', the default, the 'id' and 'slug'
##' fields are hidden from the data frame. To return these columns
##' as part of the data frame, use 'show_id = TRUE'.
##'
##' @param to_upper - should the names of the dataframe be converted to
##' upper case?
##'
##' @param add_year_col - should a 'year' column be added to the
##'   returned dataframe?  This argument is ignored if the data frame
##'   does not contain a 'prj_cd' column.
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
prepare_payload <- function(payload, show_id = FALSE, to_upper = TRUE, add_year_col=FALSE) {
  if (is.null(dim(payload))) {
    return(payload)
  }


  if (add_year_col) {
    payload <- add_year_col(payload, silent=TRUE)
  }

  if (to_upper) {
    names(payload) <- toupper(names(payload))
  }
  if (!show_id) {
    payload <- payload[, !toupper(names(payload)) %in% c("ID", "SLUG")]
  }
  return(payload)
}
