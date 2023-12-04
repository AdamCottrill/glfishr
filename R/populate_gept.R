##' Populate Gear-Effort-Proecss-Type from FN028 and FN121 tables
##'
##' The Gear-Effort-Process-Type table in the GLIS assessment table is
##' used to constrain the efforts that can appear in the FN122 table,
##' depending on the process type reported in the FN121 table and
##' associated gear type.  This function creates the records in that
##' table by fetching all of the known process types for a given gear
##' and then filter those results to include only those used in the
##' provided dataframe.
##'
##' @param fn028 - FN028-mode dataframe with coulmn 'GR'
##' @param fn121 - FN121 - net set dataframe with column 'PROCESS_TYPE'
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
populate_gept <- function(fn028, fn121) {
  # get the known gear-effort-process-types for the unique gears
  # lsted in FN028 table
  gears <- unique(fn028$GR)
  gept <- get_gear_process_types(list(gr = gears))
  fn028 <- unique(fn028[c("PRJ_CD", "MODE", "GR")])
  fn121 <- unique(fn121[c("PRJ_CD", "MODE", "PROCESS_TYPE")])
  mode_gear_proc_type <- merge(fn121, fn028, all = T)
  gr_proc_type <- unique(mode_gear_proc_type[c("GR", "PROCESS_TYPE")])
  return(merge(gr_proc_type, gept))

}
