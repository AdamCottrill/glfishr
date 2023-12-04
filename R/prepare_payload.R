#' Preform transformations to api payload before return data frame
#'
#' This function takes the dataframe returned from the api call and
#' preforms any required transformations before returning it.
#' Currently the fuction optionally removes is and slug from the data
#' frame (if they exist), and transforms all ofhte field names to
#' uppercase so that they match names that have been traditionally
#' used in FISHNET-2.  Other transfomations or modifications could be
#' added in the future.
#'
#' @param payload dataframe
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#'
prepare_payload <- function(payload, show_id = FALSE, to_upper = TRUE) {
  if (is.null(dim(payload))) {
    return(payload)
  }

  if (to_upper) {
    names(payload) <- toupper(names(payload))
  }
  if (!show_id) {
    payload <- payload[, !toupper(names(payload)) %in% c("ID", "SLUG")]
  }

  return(payload)
}
