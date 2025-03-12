##' .. content for \description{} (no empty lines) ..
##'
##' Add year to fishnet-like dataframe
##' @title Add year to fishnet-like dataframe
##' @param fn_dat - data frame with the column 'prj_cd'
##' @return data frame
##' @export
##' @author R. Adam Cottrill
add_year_col <- function(fn_data, silent = FALSE) {
  if ("year" %in% tolower(names(fn_data))) {
    return(fn_data)
  }

  prj_cd_idx <- which(tolower(names(fn_data)) == "prj_cd")
  if (!length(prj_cd_idx)) {
    if (silent) {
      return(fn_data)
    } else {
      msg <- "Dataaframe must contain a column named 'PRJ_CD' or 'prj_cd'"
      stop(msg)
    }
  }
  year <- substr(fn_data[, prj_cd_idx], 7, 8)
  year <- ifelse(as.numeric(year) <= 50,
    as.numeric(paste0("20", year)),
    as.numeric(paste0("19", year))
  )
  return(cbind(year, fn_data))
}
