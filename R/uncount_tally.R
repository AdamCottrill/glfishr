#' Uncount Tallies
#' 
#' This function "uncounts" a tally, duplicating each row a number of times
#' equal to the value in the selected tally column. It is a simplified version
#' of the tidyr function uncount(). 
#'
#' @param df FN124 table fetched from GLIS using get_FN124()
#' @param tally_col Column name where the tally is stored; enter as a string
#'
#' @return
#' @export
#'
#' @examples 
#' LOA_IA21_TW1 <- get_FN124(list(prj_cd = "LOA_IA21_TW1"))
#' LOA_IA21_TW1_long <- uncount_tally(LOA_IA21_TW1, "SIZCNT")
uncount_tally <- function(df, tally_col){
  
  long_df <- df[rep(seq(nrow(df)), df[[tally_col]]), names(df) != tally_col]
  
  rownames(long_df) <- NULL
  
  return(long_df)
}