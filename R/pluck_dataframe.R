#' Pluck a dataframe from a named list of key-value pairs
#'
#' This is a helper function that is used to extract or pluck a
#' dataframe from a named list of key-values pairs.  Api endpoints for
#' lookup-values are often in the form of key-value pairs. This
#' function selects the named element from list and returns it as a
#' dataframe with the columns 'value' and 'label'. This function is
#' not expected to be called directly, but is used by other convience
#' functions (\code{get_tag_colours()}, \code{get_tag_types()}).
#'
#' @param payload list
#'
#' @param what string
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#'
#'
pluck_dataframe <- function(payload, what = "tag_type") {
  df <- data.frame(payload[what])
  names(df) <- c("value", "label")
  return(df)
}
