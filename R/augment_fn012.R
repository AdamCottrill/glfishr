##' Augment the FN012 data
##'
##' the fn012 data downloaded from the api, may be incomplete, missing
##' species and groups that that were actually encountered in the
##' associated  projects. This function add records to the FN012 table
##' in these instances. If the missing spc-grp combinations can be
##' found in the FN012 protocols table, those values are used,
##' otherwise default values for the species are used instead.    If
##' prune=TRUE SPC-GRP combinations that appear in the FN012 table,
##' but not in the FN123 table, are dropped from the FN012 before it
##' is returned.
##' @param fn011 - dataframe contains fn011 data
##' @param fn012 - dataframe contains fn012 data fetched from the api
##' for given filters
##' @param fn123 - dataframe contains fn123 data fetched from the api
##' for given filters
##' @param prune_fn012 - boolean - should unused FN012 records be
##'   removed from the table?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012

augment_fn012 <- function(fn011, fn012, fn123, prune_fn012) {
  if (is.null(dim(fn012))) {
    # populate FN012 strictly from the lake and protocols:
    protocols <- fn011[, names(fn011) %in% c("PRJ_CD", "LAKE", "PROTOCOL")]

    # fetch the default fn012 data for each lake and protocol we need:
    fn012_protocols <- fetch_fn012_protocol_data(protocols)
    # drop unused columnt
    fn012 <- fn012_protocols[, !names(fn012_protocols) %in% c(
      "LAKE",
      "PROTOCOL"
    )]
  } else {
    # if FN012 is empty we need everything in FN123, otherwise just the
    # missing values
    in_fn012 <- with(fn012, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    need <- setdiff(in_fn123, in_fn012)

    needed_prj_cds <- unique(sapply(strsplit(need, "-"), "[[", 1))

    protocols <- fn011[
      fn011$PRJ_CD %in% needed_prj_cds,
      names(fn011) %in% c("PRJ_CD", "LAKE", "PROTOCOL")
    ]

    # fetch the defaault fn012 data for each lake and protocol we need:
    fn012_protocols <- fetch_fn012_protocol_data(protocols)
    fn012_protocols$key <- with(fn012_protocols, paste(PRJ_CD, SPC, GRP, sep = "-"))
    fn012 <- rbind(
      fn012,
      fn012_protocols[
        fn012_protocols$key %in% need,
        !names(fn012_protocols) %in% c("key", "LAKE", "PROTOCOL")
      ]
    )
  }

  fn012 <- add_missing_fn012(fn012, fn123)
  if (prune_fn012) {
    fn012 <- prune_unused_fn012(fn012, fn123)
  }

  fn012 <- fn012[order(fn012$PRJ_CD, fn012$SPC, fn012$GRP), ]

  return(fn012)
}
