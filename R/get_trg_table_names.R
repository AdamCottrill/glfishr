##' Get field names for target table
##'
##' This function connects to at target database and execute a simple
##' sql statemetn that will return an empty recordset that contains
##' nothing but the names of the columns in the target table.  This
##' list of field names can be used to modify or map existing data
##' frames to match the target table so that subsequent append queries
##' have matching schema.
##' @param trg_db - path to our target accdb file
##' @param table - the table name in the target databae to query against
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return character vector
##' @seealso sync_fields
get_trg_table_names <- function(trg_db, table) {
  conn <- RODBC::odbcConnectAccess2007(trg_db, uid = "", pwd = "")
  stmt <- sprintf("select * from [%s] where FALSE;", table)
  dat <- RODBC::sqlQuery(conn, stmt,
    as.is = TRUE, stringsAsFactors =
      FALSE, na.strings = ""
  )
  RODBC::odbcClose(conn)
  return(toupper(names(dat)))
}
