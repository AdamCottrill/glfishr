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
