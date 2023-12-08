##' Populate target database
##'
##' given a list containing our data elements and a target database,
##' iterate over the list and insert the data into the corresponding
##' table in the target database.  The names in the list must
##' correspond with the tables in the target database, and it must be
##' possible to insert the tables in alphabetical order. (which works
##' for FN-2, but may not always be the case)
##'
##' @param target - the path to the target accdb file
##' @param data - a named list containing the data to insert the
##' target db
##' @param verbose - should the table and record count be reported
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return NULL
##' @seealso append_data, populate_template_assessment
populate_db <- function(target, data, verbose) {
  for (tbl in sort(names(data))) {
    append_data(target, tbl, data[[tbl]], verbose)
  }
}




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


##' Synchronize fields in data-frame to match a database table
##'
##' This function accepts a data-frame, a database name and a table name
##' and adds and optionally removes fields from the data-frame to match
##' the names in the target table.  If drop_col=FALSE, extra fields in
##'
##' the data-frame will remain, if drop_cols=TRUE, extra fields in the
##' data-frame will be removed.
##' @param df - a dataframe
##' @param trg_db - path to our target accdb file
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



##' Populate Gear-Effort-Proecss-Type from FN028 and FN121 tables
##'
##' The Gear-Effort-Process-Type table in the GLIS assessment table is
##' used to constrain the efforts that can appear in the FN122 table,
##' depending on the process type reported in the FN121 table and
##' associated gear type.  This function creates the records in that
##' table by fetching all of the known process types for a given gear
##' and then filter those results to include only those used in the
##' provided dataframe.
##' @param fn028 - FN028-mode dataframe with coulmn 'GR'
##' @param fn121 - FN121 - net set dataframe with column 'PROCESS_TYPE'
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
populate_gept <- function(fn028, fn121) {
  # get the known gear-effort-process-types for the unique gears
  # lsted in FN028 table
  gears <- unique(fn028$GR)
  gept <- get_gear_process_types(list(gr = gears))
  fn121_fn028 <- merge(fn121, fn028, all.x = TRUE)
  # get the unique combinations of gear and process types reported in FN121
  fn121_fn028 <- unique(subset(fn121_fn028, select = c("GR", "PROCESS_TYPE")))
  # return the subset of gept that were actually used:
  return(merge(gept, fn121_fn028))
}


##' Populate the FN012-Sampling Specs Table
##'
##' This function populates the FN012 table for project selected by
##' the provided filters.  Attributes of the FN011, FN123, FN124 and
##' FN125 elements in the data list are used to augment rows and
##' their attributes in instances where those rows don't already
##' exist.  If prune_fn012 is TRUE only records with at least one
##' corresponding record in the FN123 table are returned.
##' @param filters - list of filters used to select projects
##' @param data - the named list data fetched from the api
##' @param prune_fn012 - boolean - should unused FN012 records be
##' removed from the table?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
populate_fn012 <- function(filters, glis_data, prune_fn012) {
  fn012 <- get_FN012(filters)
  fn012 <- augment_fn012(glis_data$FN011, fn012, glis_data$FN123, prune_fn012)
  fn012 <- assign_fn012_sizesam(fn012, glis_data$FN124, glis_data$FN125)
  fn012 <- fill_missing_fn012_limits(fn012)
}

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
##' @param filters - list of filters used to select projects
##' @param data - the named list data fetched from the api
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012

augment_fn012 <- function(fn011, fn012, fn123, prune_fn012) {
  if (is.null(dim(fn012))) {
    # populate FN012 strictly from the lake and protocols:
    protocols <- subset(fn011,
      select = c("PRJ_CD", "LAKE", "PROTOCOL")
    )

    # fetch the default fn012 data for each lake and protocol we need:
    fn012_protocols <- fetch_fn012_protocol_data(protocols)
    fn012 <- subset(fn012_protocols, select = -c(LAKE, PROTOCOL))
  } else {
    # if FN012 is empty we need everything in FN123, otherwise just the
    # missing values
    in_fn012 <- with(fn012, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    need <- setdiff(in_fn123, in_fn012)

    needed_prj_cds <- unique(sapply(strsplit(need, "-"), "[[", 1))
    protocols <- subset(fn011, fn011$PRJ_CD %in% needed_prj_cds,
      select = c("PRJ_CD", "LAKE", "PROTOCOL")
    )

    # fetch the defaault fn012 data for each lake and protocol we need:
    fn012_protocols <- fetch_fn012_protocol_data(protocols)
    fn012_protocols$key <- with(fn012_protocols, paste(PRJ_CD, SPC, GRP, sep = "-"))
    fn012 <- rbind(
      fn012,
      subset(fn012_protocols, fn012_protocols$key %in% need,
        select =
          -c(
            LAKE,
            PROTOCOL, key
          )
      )
    )
  }

  fn012 <- add_missing_fn012(fn012, fn123)
  if (prune_fn012) {
    fn012 <- prune_unused_fn012(fn012, fn123)
  }

  fn012 <- fn012[order(fn012$PRJ_CD, fn012$SPC, fn012$GRP), ]

  return(fn012)
}


##' Remove FN012 records without matching FN123 records
##'
##' A helper function used by populate_fn012 to removed any sampling
##' specification s for species-groups that were not encountered in a
##' project.
##' @param fn012
##' @param fn123
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso get_or_augment_fn012
prune_unused_fn012 <- function(fn012, fn123) {
  fn012$key <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_123 <- unique(with(fn123, paste(PRJ_CD, SPC, GRP, sep = "-")))
  return(subset(fn012, fn012$key %in% in_123, select = -key))
}



##' Populate FN012.SIZSAM based
##'
##' This function updates the BIOSAM values in the FN012 table based
##' on the presence of SPC-GRP records in the associated FN124 and
##' FN125.
##'
##' @param fn012 - dataframe containing FN012 sampling spec. data
##' @param fn124 - dataframe containing FN124 length tally data
##' @param fn125 - dataframe containing FN125 biological data
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
##' @seealso fill_missing_fn012_limits, populate_fn012
assign_fn012_sizesam <- function(fn012, fn124, fn125) {
  # make a unique key for proj-spc-grp
  key <- paste(fn012$PRJ_CD, fn012$SPC, fn012$GRP, sep = "_")

  # Assigning SIZSAM
  in_fn124 <- unique(paste(fn124$PRJ_CD, fn124$SPC, fn124$GRP, sep = "_"))
  in_fn125 <- unique(paste(fn125$PRJ_CD, fn125$SPC, fn125$GRP, sep = "_"))

  fn012$SIZSAM <- ifelse((key %in% in_fn124) &
    (key %in% in_fn125), 3,
  ifelse((key %in% in_fn124) & !(key %in% in_fn125), 2,
    ifelse(!(key %in% in_fn124) & (key %in% in_fn125), 1, 0)
  )
  )

  return(fn012)
}


##' Fill missing FN012 size limits
##'
##' The FN012 table has several fields that are used to bound
##' estimates of fish size and flag potential errors.  When new
##' records are added to the FN012 table, these values are null. This
##' function connects to the glis api endpoint and fetches the
##' atttributes for the missing species and updates the corresponding
##' fields in the newly created fn012 records.
##' @param fn012 - dataframe containing FN012 sampling spec. data
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012, assign_fn012_sizsam
fill_missing_fn012_limits <- function(fn012) {
  incomplete <- subset(fn012, is.na(fn012$GRP_DES))
  if (nrow(incomplete)) {
    spc_limits <- get_species(list(
      spc = unique(incomplete$SPC),
      detail = TRUE
    ))
    # select the columns that the spc_limits has in common with fn012
    spc_limits <- subset(spc_limits,
      select = names(spc_limits)[names(spc_limits) %in% names(incomplete)]
    )
    # get the columns of fn012 that are not in the spc_limits tables
    # (except for SPC)
    fn012_columns <- subset(incomplete,
      select = c("SPC", names(incomplete)[!names(incomplete) %in%
        names(spc_limits)])
    )
    missing <- merge(fn012_columns, spc_limits, by = "SPC")
    complete <- subset(fn012, !is.na(fn012$GRP_DES))
    fn012 <- rbind(complete, missing)
  }

  return(fn012)
}


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

##' Add FN012 record for missing SPC-GRPs
##'
##' This function adds records to the FN012 table for PRJ_CD-SPC-GRP
##' combinations that exist in the FN123 table (they were caught), but
##' are not currently in the FN012 (Sampling Spec) table.  This is a
##' helper function used by \code{\link{populate_fn012}} and is not
##' intended by called directly by users.
##'
##' @param fn012 Dataframe containing FN012 Sampling specs and keys "PRJ_CD", "SPC", "GRP"
##' @param fn123 Dataframe contaiing catch count data and keys "PRJ_CD", "SPC", "GRP"
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012
add_missing_fn012 <- function(fn012, fn123) {
  # finally check to see if there are any additional species not in the
  # fn012 or fn012 protocl tables. Add place holder rows for them:

  in_fn012 <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  fn123$key <- with(fn123, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_fn123 <- unique(fn123$key)
  still_missing <- setdiff(in_fn123, in_fn012)
  if (length(still_missing)) {
    keys <- c("PRJ_CD", "SPC", "GRP")
    missing <- unique(subset(fn123, fn123$key %in% still_missing, select = keys))
    fn012 <- merge(fn012, missing,
      by = keys,
      all = TRUE
    )
  }
  return(fn012)
}
