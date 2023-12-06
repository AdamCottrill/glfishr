#' Populate a GLIS template using the GLIS API
#'
#' This function accesses the API endpoints exposed by GLIS for the
#' and populates an template data with the data for projects specified
#' by the provided filter. By default, the output file is created in
#' the current working directory, and is named dynamically from the
#' values of the filter.  Alternatively, the name of the target
#' database can be provided by the user.  Execution of the function
#' will be stopped if the template cannot be found or the target
#' (output) database already exists (unless overwrite=TRUE).
#'
#' \bold{*NOTE*} this functionality is provided to facilitate
#' updating, correcting and augmenting projects in GLIS.  Changes made
#' to the downloaded data should be uploaded back into GLIS as soon as
#' possible. Downloaded data is not intended for long-term storage or
#' subsequent data analysis. Data analysis and reporting should always
#' be completed using data fetched directly from the API.
#'
#'
#' @param filters a named list of filters used to select the
#'   project(s) that will be inserted into the target database.
#' @param template_database Character string. The path to the template
#'   database that will be copied and populated with data from GLIS.
#' @param target The name of the target (output) database file. If no
#'   target is provide, a name will be built from the filter list.
#' @param source - string  either 'assessment' or 'creel'
#' @param overwrite - Boolean. If a file with the same name as target,
#'   should it be overwritten?
#' @param prune_fn012 - Boolean - should records in the FN012 table
#'   without any matching records in the FN123 (Catch counts) be
#'   deleted?
#' @param verbose - Boolean. Should progress be reported to the console?
#'
#' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
#'
#' @export
#' @examples
#' \dontrun{
#' populate_template(
#'   list(prj_cd = "LEA_IA17_097"), "Great_Lakes_Assessment_Template_5.accdb"
#' )
#'
#' populate_template(
#'   list(prj_cd = "LEA_IA23_SHA"), "Great_Lakes_Assessment_Template_5.accdb",
#'   "IBHN_2023_GLAT5.accdb"
#' )
#'
#' populate_template(
#'   list(prj_cd = "LEA_IA22_093"), "Great_Lakes_Assessment_Template_5.accdb",
#'   "LPBTW_093_2023.accdb",
#'   prune_fn012 = TRUE
#' )
#' }
populate_template <- function(filters, template_database,
                              target = NULL,
                              source = c("assessment", "creel"),
                              overwrite = FALSE,
                              prune_fn012 = FALSE,
                              verbose = TRUE) {
  source <- match.arg(source)

  fname <- paste(sapply(filters, paste), collapse = "-")
  if (is.null(target)) {
    target <- file.path(getwd(), sprintf("%s.accdb", fname))
  }

  if (file.exists(target) && !overwrite) {
    messageA <- sprintf("The target database: '%s' already exists.", target)
    messageB <- "Please provide a different target or set overwrite=TRUE."
    stop(paste(messageA, messageB, sep = "\n"))
  }

  if (!file.exists(template_database)) {
    message <-
      sprintf(
        "Could not find the template database '%s'. Make sure it exists and try again",
        template_database
      )
    stop(message)
  } else {
    file.copy(template_database, target, overwrite = overwrite)
  }


  # we will use a list to gather our data - the names of the list
  # elements must match the names of their corresponding table in the
  # template database.

  glis_data <- list()

  if (source == "assessment") {
    glis_data <- get_assessment_data(filters, prune_fn012, verbose)
  } else {
    glis_data <- get_creel_data(filters, prune_fn012, verbose)
  }

  validate_glis_data(glis_data)
  # Append the data
  populate_db(target, glis_data, verbose)
}


##' Check data returned from api before inserting into template
##'
##' This function runs a number of checks againts the glis data list
##' returned from teh api before it is inserted into the target
##' database.  If an error is found, the function is stopped and an
##' error message is presented to the user.
##'
##' @param glis_data named list compiled from the glis api endpoints
##' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
##' @return named list
validate_glis_data <- function(glis_data) {
  # put this in a vadator function:
  ## Are all SPC values in glis_data$FN123 also in glis_data$FN012?
  if (!is.null(dim(glis_data$FN123))) {
    in_fn012 <- with(glis_data$fn012, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    in_fn123 <- with(glis_data$fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    extra <- setdiff(in_fn123, in_fn012)
    if (length(extra)) {
      stop(paste0(
        "A record in the FN123 table has a PRJ_CD-SPC-GRP combination ",
        "that is not included in the FN012 table. An FN012 record will need to be ",
        "added for this PRJ_CD-SPC-GRP before continuing."
      ))
    }
  }
  # Are all SUBSPACE values associated with a known SPACE?
  space_check <- as.vector(unique(glis_data$FN026_Subspace$SPACE))
  if (any(!(space_check %in% glis_data$FN026$SPACE))) {
    stop(paste0(
      "There is a SPACE value in the FN016_Subspace table that does",
      " not exist in the FN026 table."
    ))
  }

  # Do all FN121 records have a valid SUBSPACE?
  fn121_subspace_check <- as.vector(unique(glis_data$FN121$SUBSPACE))
  if (any(!(glis_data$FN121_SUBspace_check %in% glis_data$FN026_Subspace$SUBSPACE))) {
    stop(paste0(
      "There is a SUBSPACE value in the FN121 table that does not exist in",
      " the FN026_Subspace table."
    ))
  }

  # Do all Stream_Dimension records have a valid SUBSPACE?
  sd_subspace_check <- as.vector(unique(glis_data$Stream_Dimensions$SUBSPACE))
  if (any(!(sd_subspace_check %in% glis_data$FN026_Subspace$SUBSPACE))) {
    stop(paste0(
      "There is a SUBSPACE value in the Stream_Dimensions table that ",
      "does not exist in the FN026_Subspace table."
    ))
  }

  glis_data
}



##' Report fetching activity to the console
##'
##' A little helper funciton used by populate template to provide some
##' feedback ot the user and report progress.  This function is not
##' intended to be called anywhere  other than from within
##' populate_template functions.
##'
##' @param table_name - stirng. The name of the table to report on
##' @param verbose - boolean. should the message be printed?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##'
fetching_report <- function(table_name, verbose) {
  if (verbose) {
    print(sprintf("Fetching data from table '%s'", table_name))
  }
}

##' connect the api and get data from assessment portal
##'
##' This is one of the workhorse functions used by populate_template.
##' This function connects to the assessment portal and fetches all of
##' the data selected by the filters argument.  Returns a named list-
##' names of the list correspond directly to names of the tables in
##' template database.
##'
##' @param filters - list of filters passed to glis api endpoints
##' @param prune_fn012 - boolean. Should records in the FN012 table
##' without records in the FN123 be dropped?
##' @param verbose - boolean.  Should progress be reproted in the console?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return named list
get_assessment_data <- function(filters, prune_fn012, verbose) {
  glis_data <- list()
  fetching_report("FN011", verbose)
  glis_data$FN011 <- get_FN011(filters)
  if (is.null(dim(glis_data$FN011))) {
    message <- paste0(
      sprintf("No Projects could not be found in *FN_PORTAL* using supplied filters:\n"),
      paste(names(filters), filters, sep = " = ", collapse = ", ")
    )
    stop(message)
  }

  # Import the data for all of other tables
  fetching_report("FN022", verbose)
  glis_data$FN022 <- get_FN022(filters)
  fetching_report("FN026", verbose)
  glis_data$FN026 <- get_FN026(filters)
  fetching_report("FN026_subspace", verbose)
  glis_data$FN026_Subspace <- get_FN026_Subspace(filters)
  fetching_report("FN028", verbose)
  glis_data$FN028 <- get_FN028(filters)
  fetching_report("FN121", verbose)
  glis_data$FN121 <- get_FN121(filters)
  fetching_report("FN121_Limno", verbose)
  fn121_limno <- get_FN121_Limno(filters)
  fetching_report("FN121_Trapnet", verbose)
  fn121_trapnet <- get_FN121_Trapnet(filters)
  fetching_report("FN121_Trawl", verbose)
  fn121_trawl <- get_FN121_Trawl(filters)
  fetching_report("FN121_Weather", verbose)
  fn121_weather <- get_FN121_Weather(filters)
  fetching_report("FN121_Electrofishing", verbose)
  glis_data$FN121_Electrofishing <- get_FN121_Electrofishing(filters)
  fetching_report("FN122", verbose)
  glis_data$FN122 <- get_FN122(filters)
  fetching_report("FN123", verbose)
  glis_data$FN123 <- get_FN123(filters)
  fetching_report("FN123_NonFish", verbose)
  glis_data$FN123_NonFish <- get_FN123_NonFish(filters)
  fetching_report("FN124", verbose)
  glis_data$FN124 <- get_FN124(filters)
  fetching_report("FN125", verbose)
  glis_data$FN125 <- get_FN125(filters)
  fetching_report("FN125_Lamprey", verbose)
  glis_data$FN125_lamprey <- get_FN125_Lamprey(filters)
  fetching_report("FN125_Tags", verbose)
  glis_data$FN125_tags <- get_FN125_Tags(filters)
  fetching_report("FN126", verbose)
  glis_data$FN126 <- get_FN126(filters)
  fetching_report("FN127", verbose)
  glis_data$FN127 <- get_FN127(filters)
  fetching_report("Stream Dimensions", verbose)
  glis_data$Stream_Dimensions <- get_Stream_Dimensions(filters)

  # fetching_report("FN121_GPS_Tracks")
  # glis_data$FN121_GPS_Tracks <- get_FN121_GPS_Tracks(filters)


  glis_data$FN011$LAKE <- glis_data$FN011$LAKE.ABBREV
  fetching_report("FN012", verbose)
  glis_data$FN012 <- populate_fn012(filters, glis_data, prune_fn012)

  print("Building Gear_Effort_Process_Types...")
  glis_data$Gear_Effort_Process_Types <- populate_gept(glis_data$FN028, glis_data$FN121)

  #-------------------------------------------------------------------------
  # Table Adjustments

  # this will break when the proejct lead api is cleanded up
  glis_data$FN011$PRJ_LDR <- paste(
    glis_data$FN011$PRJ_LDR.FIRST_NAME,
    glis_data$FN011$PRJ_LDR.LAST_NAME
  )

  # Minor fixes
  glis_data$FN121$COVER <- glis_data$FN121$COVER_TYPE
  glis_data$FN121$BOTTOM <- glis_data$FN121$BOTTOM_TYPE

  if (!is.null(dim(fn121_limno))) {
    glis_data$FN121 <- merge(glis_data$FN121, fn121_limno, all.x = TRUE)
  }
  if (!is.null(dim(fn121_trapnet))) {
    glis_data$FN121 <- merge(glis_data$FN121, fn121_trapnet, all.x = TRUE)
  }
  if (!is.null(dim(fn121_trawl))) {
    glis_data$FN121 <- merge(glis_data$FN121, fn121_trawl, all.x = TRUE)
  }
  if (!is.null(dim(fn121_weather))) {
    glis_data$FN121 <- merge(glis_data$FN121, fn121_weather, all.x = TRUE)
  }
  return(glis_data)
}



##' connect the api and get data from the creel portal
##'
##' This is one of the workhorse functions used by populate_template.
##' This function connects to the creel portal and fetches all of the
##' data selected by the filters argument.  Returns a named list-
##' names of the list correspond directly to names of the tables in
##' template database.
##' @param filters - list of filters passed to glis api endpoints
##' @param prune_fn012 - boolean. Should records in the FN012 table
##'   without records in the FN123 be dropped?
##' @param verbose - boolean.  Should progress be reproted in the
##'   console?
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return named list
##'
get_creel_data <- function(filters, prune_fn012, verbose) {
  glis_data <- list()
  fetching_report("SC011", verbose)
  glis_data$FN011 <- get_SC011(filters)
  if (is.null(dim(glis_data$FN011))) {
    message <- paste0(
      sprintf("No Projects could not be found in *CREEL_PORTAL* using supplied filters:\n"),
      paste(names(filters), filters, sep = " = ", collapse = ", ")
    )
    stop(message)
  }

  # Import the data for all of other tables
  fetching_report("SC022", verbose)
  glis_data$FN022 <- get_SC022(filters)
  fetching_report("SC023", verbose)
  glis_data$FN023 <- get_SC023(filters)
  fetching_report("SC024", verbose)
  glis_data$FN024 <- get_SC024(filters)
  fetching_report("SC025", verbose)
  glis_data$FN025 <- get_SC025(filters)
  fetching_report("SC026", verbose)
  glis_data$FN026 <- get_SC026(filters)
  fetching_report("SC026_subspace", verbose)
  glis_data$FN026_Subspace <- get_SC026_Subspace(filters)
  fetching_report("SC028", verbose)
  glis_data$FN028 <- get_SC028(filters)
  fetching_report("SC111", verbose)
  glis_data$FN111 <- get_SC111(filters)
  fetching_report("SC112", verbose)
  glis_data$FN112 <- get_SC112(filters)
  fetching_report("SC121", verbose)
  glis_data$FN121 <- get_SC121(filters)

  fetching_report("SC123", verbose)
  FN123 <- get_SC123(filters)
  FN123$EFF <- "001"
  glis_data$FN123 <- FN123

  fetching_report("SC124", verbose)
  FN124 <- get_SC124(filters)
  FN124$EFF <- "001"
  glis_data$FN124 <- FN124

  fetching_report("SC125", verbose)
  FN125 <- get_SC125(filters)
  FN125$EFF <- "001"
  glis_data$FN125 <- FN125

  fetching_report("SC125_Lamprey", verbose)
  FN125_lamprey <- get_SC125_Lamprey(filters)
  FN125_lamprey$EFF <- "001"
  glis_data$FN125_Lamprey <- FN125_lamprey

  fetching_report("SC125_Tags", verbose)
  FN125_tags <- get_SC125_Tags(filters)
  FN125_tags$EFF <- "001"
  glis_data$FN125_Tags <- FN125_tags

  fetching_report("SC126", verbose)
  FN126 <- get_SC126(filters)
  FN126$EFF <- "001"
  glis_data$FN126 <- FN126

  fetching_report("SC127", verbose)
  FN127 <- get_SC127(filters)
  FN127$EFF <- "001"
  glis_data$FN127 <- FN127

  fetching_report("SC012", verbose)

  glis_data$FN012 <- populate_fn012(
    filters, glis_data, prune_fn012,
    source = "creel"
  )

  return(glis_data)
}


##' Add FN012 record for missing SPC-GRPs
##'
##' This function adds records to the FN012 table for PRJ_CD-SPC-GRP
##' combinations that exist in the FN123 table (they were caught), but
##' are not currently in the FN012 (Sampling Spec) table.  This is a
##' helper function used by \code{\link{populate_fn012}} and is not
##' intended by called directly by users.
##'
##' @param fn012 Dataframe containing FN012 Sampling specs and keys
##'   "PRJ_CD", "SPC", "GRP"
##' @param fn123 Dataframe containing catch count data and keys
##'   "PRJ_CD", "SPC", "GRP"
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012
add_missing_fn012 <- function(fn012, fn123) {
  # finally check to see if there are any additional species not in
  # the fn012 or fn012 protocl tables. Add place holder rows for them:

  # there might not be any catch data yet - if so, just return the
  # fn012 as it was recieved.
  if (is.null(dim(fn123))) {
    return(fn012)
  }

  in_fn012 <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  fn123$key <- with(fn123, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_fn123 <- unique(fn123$key)
  still_missing <- setdiff(in_fn123, in_fn012)
  if (length(still_missing)) {
    keys <- c("PRJ_CD", "SPC", "GRP")
    missing <- unique(fn123[
      fn123$key %in% still_missing,
      names(fn123) %in% keys
    ])
    fn012 <- merge(fn012, missing,
      by = keys,
      all = TRUE
    )
  }


  return(fn012)
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
      safer = safer, append = append
    )
    return(RODBC::odbcClose(conn))
  }
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



##' Augment the FN012 data
##'
##' the fn012 data downloaded from the api, may be incomplete, missing
##' species and groups that that were actually encountered in the
##' associated  projects. This function adds records to the FN012 table
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
##' @param source - string. Either "assessment" or "creel"
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso populate_fn012
augment_fn012 <- function(fn011, fn012, fn123, prune_fn012, source) {
  if (source == "assessment") {
    fn011_flds <- c("PRJ_CD", "LAKE", "PROTOCOL")
    extra_fn012_flds <- c("LAKE", "PROTOCOL")
    fetch_012_protocol <- function(protocols) {
      fetch_fn012_protocol_data(protocols)
    }
  } else {
    fn011_flds <- c("PRJ_CD", "LAKE")
    extra_fn012_flds <- c("LAKE")
    fetch_012_protocol <- function(protocols) {
      fetch_sc012_protocol_data(protocols)
    }
  }


  # get the default FN012 prtocol values for all of the projects
  # included in the FN011 - returns default values with PRJ_CD field
  project_protocols <- fn011[, names(fn011) %in% fn011_flds]
  fn012_defaults <- fetch_012_protocol(project_protocols)
  fn012_defaults$key <- with(fn012_defaults, paste(PRJ_CD, SPC, GRP, sep = "-"))

  # check the dimensions of the FN012:
  # if it is empty use the default values we just got
  if (is.null(dim(fn012))) {
    fn012 <- fn012_defaults
    fn012 <- fn012[, !names(fn012) %in% extra_fn012_flds]
  }

  # check the entries in fn012 table with those in the fn123
  # if there are any missing values, add them from the defaults

  # if FN012 is empty we need everything in FN123, otherwise just the
  # missing values
  in_fn012 <- with(fn012, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
  if (is.null(dim(fn123))) {
    need <- c()
  } else {
    in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
    need <- setdiff(in_fn123, in_fn012)
  }

  if (!is.null(dim(need))) {
    fn012 <- rbind(
      fn012,
      fn012_defaults[
        fn012_defaults$key %in% need,
        !names(fn012_defaults) %in% append(extra_fn012_flds, "key")
      ]
    )
  }
  # if there are still missing values get them from the SPC table -
  # leaving the sampling fields empty.
  fn012 <- add_missing_fn012(fn012, fn123)

  # prune the fn012 to just the spc-grp sampled if prune TRUE
  if (prune_fn012) {
    fn012 <- prune_unused_fn012(fn012, fn123)
  }

  fn012 <- fn012[order(fn012$PRJ_CD, fn012$SPC, fn012$GRP), ]

  return(fn012)
}




##' Fill missing FN012 size limits
##'
##' The FN012 table has several fields that are used to bound
##' estimates of fish size and flag potential errors.  When new
##' records are added to the FN012 table, these values are null. This
##' function connects to the glis api endpoint and fetches the
##' attributes for the missing species and updates the corresponding
##' fields in the newly created fn012 records.
##'
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
      fn012_protocol <- rbind(fn012_protocol, payload)
    }
  }
  return(fn012_protocol)
}


##' Fetch SC012 data for a lake
##'
##' Given a dataframe with columns PRJ_CD, and LAKE , fetch
##' the default fish sampling specs (FN012 records) for that creels
##' run in that lake. This is a helper function that is called by
##' get_or_augment_fn012 for creel projects.
##' @param protocols - dataframe with the columns "PRJ_CD", "LAKE",
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return datarame
##' @seealso get_or_augment_fn012
fetch_sc012_protocol_data <- function(protocols) {
  # protocols is a dataframe with the columns "PRJ_CD", "LAKE"
  for (i in 1:nrow(protocols)) {
    payload <- get_SC012_Protocol(list(
      lake = protocols$LAKE[i]
    ))
    payload$PRJ_CD <- protocols$PRJ_CD[i]
    if (i == 1) {
      fn012_protocol <- payload
    } else {
      fn012_protocol <- rbind(fn012_protocol, payload)
    }
  }
  return(fn012_protocol)
}



##' Get field names for target table
##'
##' This function connects to at target database and execute a simple
##' sql statement that will return an empty record set that contains
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


##' Populate the FN012-Sampling Specs Table
##'
##' This function populates the FN012 table for project selected by
##' the provided filters.  Attributes of the FN011, FN123, FN124 and
##' FN125 elements in the data list are used to augment rows and their
##' attributes in instances where those rows don't already exist.  If
##' \code{prune_fn012} is TRUE only records that do not have any
##' corresponding entries in the FN123 table are dropped.
##'
##' @param filters - list of filters used to select projects
##' @param glis_data - the named list data fetched from the glis api
##' @param prune_fn012 - boolean - should unused FN012 records be
##'   removed from the table?
##'
##' @param source - 'assessment' or 'creel'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
populate_fn012 <- function(filters, glis_data, prune_fn012,
                           source = c("assessment", "creel")) {
  source <- match.arg(source)
  if (source == "assessment") {
    fn012 <- get_FN012(filters)
  } else {
    fn012 <- get_SC012(filters)
  }
  fn012 <- augment_fn012(
    glis_data$FN011, fn012, glis_data$FN123,
    prune_fn012, source
  )
  fn012 <- assign_fn012_sizesam(fn012, glis_data$FN124, glis_data$FN125)
  fn012 <- fill_missing_fn012_limits(fn012)
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


##' Perform transformations to api payload before return data frame
##'
##' This function takes the dataframe returned from the api call and
##' preforms any required transformations before returning it.
##' Currently the fuction optionally removes is and slug from the data
##' frame (if they exist), and transforms all ofhte field names to
##' uppercase so that they match names that have been traditionally
##' used in FISHNET-2.  Other transfomations or modifications could be
##' added in the future.
##'
##' @param payload dataframe
##' @param show_id When 'FALSE', the default, the 'id' and 'slug'
##' fields are hidden from the data frame. To return these columns
##' as part of the data frame, use 'show_id = TRUE'.
##' @param to_upper - should the names of the dataframe be converted to
##' upper case?
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
prepare_payload <- function(payload, show_id = FALSE, to_upper = TRUE) {
  if (is.null(dim(payload))) {
    return(payload)
  }

  if (to_upper) {
    names(payload) <- toupper(names(payload))
  }
  if (!show_id) {
    payload <- payload[, !toupper(names(payload)) %in% c("ID", "SLUG")]
  }

  return(payload)
}


##' Remove FN012 records without matching FN123 records
##'
##' A helper function used by populate_fn012 to removed any sampling
##' specification s for species-groups that were not encountered in a
##' project.
##' @param fn012 - dataframe with columns PRJ_CD, SPC, and GRP
##' containing sampling specifications
##' @param fn123 - dataframe with columns PRJ_CD, SPC, and GRP
##' containing catch count information.
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe
##' @seealso get_or_augment_fn012
prune_unused_fn012 <- function(fn012, fn123) {
  # there might not be any catch data yet - if so, just return the
  # fn012 as it was recieved.
  if (is.null(dim(fn123))) {
    return(fn012)
  }

  fn012$key <- with(fn012, paste(PRJ_CD, SPC, GRP, sep = "-"))
  in_fn123 <- with(fn123, unique(paste(PRJ_CD, SPC, GRP, sep = "-")))
  extra <- setdiff(fn012$key, in_fn123)

  # fn012 <- subset(fn012, fn012$key %in% in_123, select = -"key"))
  fn012 <- fn012[
    !fn012$key %in% extra,
    names(fn012) != "key"
  ]


  return(fn012)
}


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
