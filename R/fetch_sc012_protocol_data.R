##' Fetch SC012 data for a lake
##'
##' Given a dataframe with columns PRJ_CD, and LAKE , fetch
##' the default fish sampling specs (FN012 records) for that creels
##' run in that lake. This is a helper function that is called by
##' get_or_augment_fn012 for creel projects.
##' @param protocols - dataframe with the columns "PRJ_CD", "LAKE",
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return datarame
##' @seealso get_or_augment_fn012
fetch_sc012_protocol_data <- function(protocols) {
  # protocols is a dataframe with the columns "PRJ_CD", "LAKE"
  for (i in 1:nrow(protocols)) {
    payload <- get_SC012_Protocol(list(
      lake = protocols$LAKE[i]
    ))
    payload$PRJ_CD <- protocols$PRJ_CD[i]
    if (i == 1) {
      fn012_protocol <- payload
    } else {
      fn012_protocol <- rbind(fn012_protocol, payload)
    }
  }
  return(fn012_protocol)
}
