##' Fetch FN012 data for lake-protocols
##'
##' Given a dataframe with columns PRJ_CD, LAKE and PROTOCOL, fetch
##' the default fish sampling specs (FN012 records) for that protocol
##' in that lake. This is a helper function that is called by
##' get_or_augment_fn012.
##' @param protocols - dataframe with the columns "PRJ_CD", "LAKE",
##'   "PROTOCOL"
##' @param fn012 - dataframe containing FN012 sampling spec. data
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return datarame
##' @seealso get_or_augment_fn012
fetch_fn012_protocol_data <- function(protocols) {
  # protocols is a dataframe with the columns "PRJ_CD", "LAKE", "PROTOCOL"
  for (i in 1:nrow(protocols)) {
    payload <- get_FN012_Protocol(list(
      lake = protocols$LAKE[i],
      protocol = protocols$PROTOCOL[i]
    ))
    payload$PRJ_CD <- protocols$PRJ_CD[i]
    if (i == 1) {
      fn012_protocol <- payload
    } else {
      fn012_protocol <- rbind(fn012_prtocol, payload)
    }
  }
  return(fn012_protocol)
}
