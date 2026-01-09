##' The add_year_col is used by many of the functions glfishr but can
##' also be used independently to add a year column to a "FishNet-2"
##' like dataframe that contains a PRJ_CD column.  If the data frame
##' does not contain column "PRJ_CD" or "prj_cd" an error will be
##' thrown. If the data frame already contains a Year column, it will
##' be returned unchanged.
##'
##' Add year to fishnet-like dataframe
##' @title Add year to fishnet-like dataframe
##' @param fn_data - data frame with the column 'prj_cd'
##' @param silent - should the warnings be suppressed
##'
##' @return data frame
##' @export
##' @author R. Adam Cottrill
add_year_column <- function(fn_data, silent = FALSE) {
  if ("year" %in% tolower(names(fn_data))) {
    return(fn_data)
  }

  prj_cd_idx <- which(tolower(names(fn_data)) == "prj_cd")
  if (!length(prj_cd_idx)) {
    if (silent) {
      return(fn_data)
    } else {
      msg <- "Dataframe must contain a column named 'PRJ_CD' or 'prj_cd'"
      stop(msg)
    }
  }
  year <- substr(fn_data[, prj_cd_idx], 7, 8)
  year <- ifelse(
    as.numeric(year) <= 50,
    as.numeric(paste0("20", year)),
    as.numeric(paste0("19", year))
  )
  return(cbind(year, fn_data))
}
