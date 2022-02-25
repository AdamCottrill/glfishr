#' Get the list of values for tag attributes from the TFAT api
#'
#' This function accesses the tfat lookup api endpoint and extracts the
#' available values for  tag colour, placement, type, status (applied/on
#' capture), or tag origin (i.e. - tagging agency). The tag data is returned as
#' a data frame with the columns 'value' and 'label'.
#'
#' @param what string
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return dataframe
#'
#' @export
#'
#' @examples
#'
#' tag_origins <- get_tag_attr_values("tag_origin")
#'
#' tag_colours <- get_tag_attr_values("tag_colour")
#'
#' tag_tag_types <- get_tag_attr_values("tag_type")
#'
#' tag_positions <- get_tag_attr_values("tag_position")
#'
#' tagstats <- get_tag_attr_values("tagstat")
get_tag_attr_values <- function(what = c(
                                  "tag_origin", "tag_colour",
                                  "tag_type", "tag_position", "tagstat"
                                )) {
  what <- match.arg(what)
  payload <- fetch_tfat_lookups()
  values <- pluck_dataframe(payload, what)
  return(values)
}
