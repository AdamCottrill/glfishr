##' Synchornize fields in dataframe to match a database table
##'
##' This function accepts a dataframe, a databae name and a table name
##' and adds and optionally removes fields from the dataframe to match
##' the names in the target table.  If drop_col=FALSE, extra fields in
##'
##' the dataframe will remain, if drop_cols=TRUE, extra fields in the
##' dataframe will be removed.
##' @param df - a dataframe
##' @param targ_db - path to our target accdb file
##' @param tablename - the table name in the target databae to query against
##' @param drop_cols - Boolean, Should extra names in the dataframe be dropped?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso  get_trg_table_names
sync_flds <- function(df, targ_db, tablename, drop_cols = TRUE) {
  # add any missing fields to our data frame, and delte any extras
  field_names <- get_trg_table_names(targ_db, tablename)

  # get rid of any extra names
  extra <- setdiff(names(df), field_names)
  if (length(extra) && drop_cols) {
    df <- df[, !(names(df) %in% extra)]
  }

  # add any we are missing
  missing <- data.frame(matrix(ncol = length(field_names), nrow = 0))
  colnames(missing) <- field_names
  df <- merge(df, missing, all.x = TRUE)

  return(df)
}
