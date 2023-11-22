##' Append dataframe to Access table
##'
##' This function will attempt to append data contianed in a dataframe
##' to a table in the target database.  If verbose=TRUE, a statement
##' including the number of records effected will be reported to the
##' console.
##' @param dbase - path to our target database
##' @param trg_table - the table in the target data to insert data into
##' @param data - dataframe to append in the target table
##' @param verbose - should the number of records and table be printed?
##' @param append - append to and existing table, or drop and create it?
##' @param safer - passed to RODBC::sqlSave
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return status of closed RODBC connection.
##' @export
append_data <- function(dbase, trg_table, data, verbose = T, append = T, safer =
                          T) {
  if (!is.null(dim(data))) {
    if (verbose) {
      record_count <- nrow(data)
      if (record_count == 1) {
        record_string <- sprintf("1 record")
      } else {
        record_string <- sprintf("%d records", record_count)
      }

      print(sprintf(
        "Inserting %s into the %s table", record_string,
        trg_table
      ))
    }

    data <- sync_flds(data, dbase, trg_table)


    conn <- RODBC::odbcConnectAccess2007(dbase, uid = "", pwd = "")
    RODBC::sqlSave(conn, data,
      tablename = trg_table, rownames = F, fast = TRUE,
      safer = safer, append = append, nastring = NULL
    )
    return(RODBC::odbcClose(conn))
  }
}
