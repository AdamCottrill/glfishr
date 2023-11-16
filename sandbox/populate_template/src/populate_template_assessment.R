#' Populate an Assessment Portal template using the GLIS API
#'
#' This function accesses the API endpoints for the Assessment Portal (FN_Portal)
#' tables of a specified project code and imports these records into a specified
#' template database file. By default, the file path is assumed to be the user's
#' home directory (typically 'Documents'). An alternate file path can be specified
#' using the ' template_database' option (). This function was designed based on the Great_Lakes_Assessment_Template_5 format.
#'
#'
#' There are a few important considerations when running this function:
#'  - The Project Code (prj_cd) must be submitted in quotation marks.
#'  - The 'target' parameter must include the file type in the name (e.g., DATABASE.accdb).
#'  It must also be submitted in quotation marks.
#'  - The ' template_database' must have all backslashes replaced with forward slashes and
#'  exclude the name of the target database (it will be appended based on 'target'). It
#'   must also be submitted in quotation marks.
#'  - The 'skip_fn012' option assumes that the FN011 and FN012 tables are completed in
#'  the target template database. Setting this option to 'TRUE' will (1) compare the
#'  FN012 table in the template against the FN123 table from GLIS and,
#'  (2) skip the import steps for for the FN011 and FN012 tables.
#'
#'
#'  =====================================================================
#'  AC NOTES:
#'
#'  + paths should be relative to current working directory rather
#' than the users home directory
#'
#'  + if the FN012 endpoint is empty for this project, add the records dynamically by
#' grouping on fn123.spc and grp codes.  - these will have to be
#' reviewed and updated but could be started by looking at data in the
#' FN124 and FN125 tables.
#'
#' + alternative_path changed to template_database
#'
#' + the name and path the tempalte can't be null. We need to know
#' were to find the contain that we are going to populate
#'
#' + the target could be null, if you don't provide a name, we will
#' use project code and place it in the current working directory.
#'
#'
#'
#' =====================================================================
#'
#' @param prj_cd The associated Project Code.
#' @param target The name of the target (output) database file.
#' @param template_database An optinal path to the template database
#' that will be copied and populated with data
#' @param skip_fn012 Optional parameter to identify if the FN012 table has been
#' filled-out in the target template database. The default is 'FALSE'.
#'
#'
#' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
#' @return
#' @export
#' @examples
#'
#' populate_template_assessment("LEA_IA17_097", "
#' Great_Lakes_Assessment_Template_5.accdb")
#'
#' populate_template_assessment(
#'   "LEA_IA23_SHA", "IBHN_2023_GLAT5.accdb",
#'   "C:/Users/BonsallAr/OneDrive - Government of Ontario/Documents/Research Programs/Inner Bay Hoopnet"
#' )
#'
#' populate_template_assessment("LEA_IA22_093",
#' "LPBTW_093_2023.accdb", skip_fn012 = TRUE)
populate_template_assessment <- function(filters, template_database,
                                         target = NULL, verbose = TRUE) {

  if (is.null(target)) {
    fname <- paste(sapply(filters, paste), collapse = "-")
    target <- file.path(getwd(), sprintf("%s.accdb", fname))
  }

  if (!file.exists(template_database)) {
    message <-
      sprintf(
        "Could not find the template database '%s'. Make sure it exists and try again",
        template_database
      )
    stop(message)
  } else {
    file.copy(template_database, target, overwrite = TRUE)
  }

  # a little helper function
  report <- function(table_name) {
    if (verbose) {
      print(sprintf("Fetching data from table '%s'", table_name))
    }
  }

  #we will use a list to gather our data - the names of the list
  #elements must match the names of their corresponding table in the
  #template database.
  data <- list()

  report("FN011")
  data$FN011 <- get_FN011(filters)
  if (is.null(dim(data$FN011))) {
    message <-
      sprintf("No Projects could not be found in FN_PORTAL using supplied filters")
    stop(message)
  }

  # Import the data for all of other tables
  report("FN022")
  data$FN022 <- get_FN022(filters)
  report("FN026")
  data$FN026 <- get_FN026(filters)
  report("FN026_subspace")
  data$FN026_Subspace <- get_FN026_Subspace(filters)
  report("FN028")
  data$FN028 <- get_FN028(filters)
  report("FN121")
  data$FN121 <- get_FN121(filters)
  report("FN121_Limno")
  fn121_limno <- get_FN121_Limno(filters)
  report("FN121_Trapnet")
  fn121_trapnet <- get_FN121_Trapnet(filters)
  report("FN121_Trawl")
  fn121_trawl <- get_FN121_Trawl(filters)
  report("FN121_Weather")
  fn121_weather <- get_FN121_Weather(filters)
  report("FN121_Electrofishing")
  data$FN121_Electrofishing <- get_FN121_Electrofishing(filters)
  report("FN122")
  data$FN122 <- get_FN122(filters)
  report("FN123")
  data$FN123 <- get_FN123(filters)
  report("FN123_NonFish")
  data$FN123_NonFish <- get_FN123_NonFish(filters)
  report("FN124")
  data$FN124 <- get_FN124(filters)
  report("FN125")
  data$FN125 <- get_FN125(filters)
  report("FN125_Lamprey")
  data$FN125_lamprey <- get_FN125_Lamprey(filters)
  report("FN125_Tags")
  data$FN125_tags <- get_FN125_Tags(filters)
  report("FN127")
  data$FN126 <- get_FN126(filters)
  report("FN127")
  data$FN127 <- get_FN127(filters)
  report("Stream Dimensions")
  data$Stream_Dimensions <- get_Stream_Dimensions(filters)

  # report("FN121_GPS_Tracks")
  # data$FN121_GPS_Tracks <- get_FN121_GPS_Tracks(filters)


  data$FN011$LAKE <- data$FN011$LAKE.ABBREV
  report("FN012")
  data$FN012 <- get_FN012(filters)


  # THIS assumes that the FN012 is either absent of 100% complete
  # it may be incomplete and need to be augmented before proceeding.

  if (is.null(dim(data$FN012))) {
    print("No FN012 data found. Building FN012 table from FN123...")
    # print warning that the FN012 was automatically created from the
    # FN123 table - and should be checked for accuracy
    data$FN012 <- populate_fn012(data$FN011, data$FN123)
    data$FN012 <- assign_fn012_sizesam(data$FN012, data$FN124, data$FN125)
    data$FN012 <- fill_missing_fn012_limits(data$FN012)
  }

  print("Building Gear_Effort_Process_Types...")
  data$Gear_Effort_Process_Types <- populate_gept(data$FN028, data$FN121)

  #-------------------------------------------------------------------------
  # Table Adjustments

  # this will break when the proejct lead api is cleanded up
  data$FN011$PRJ_LDR <- paste(data$FN011$PRJ_LDR.FIRST_NAME,
    data$FN011$PRJ_LDR.LAST_NAME)

  # Minor fixes
  data$FN121$COVER <- data$FN121$COVER_TYPE
  data$FN121$BOTTOM <- data$FN121$BOTTOM_TYPE

  if (!is.null(dim(fn121_limno))) {
    data$FN121 <- merge(data$FN121, fn121_limno, all.x = TRUE)
  }
  if (!is.null(dim(fn121_trapnet))) {
    data$FN121 <- merge(data$FN121, fn121_trapnet, all.x = TRUE)
  }
  if (!is.null(dim(fn121_trawl))) {
    data$FN121 <- merge(data$FN121, fn121_trawl, all.x = TRUE)
  }
  if (!is.null(dim(fn121_weather))) {
    data$FN121 <- merge(data$FN121, fn121_weather, all.x = TRUE)
  }


  #-------------------------------------------------------------------------
  # Table Relationship Validation

  # Are all SPC values in data$FN123 also in data$FN012?
  SPC_ALIGN <- subset(data$FN123, select = c("PRJ_CD", "SPC", "GRP"))
  SPC_ALIGN <- unique(SPC_ALIGN)
  SPC_ALIGN <- merge(SPC_ALIGN, data$FN012, all.x = TRUE)
  if (any(is.na(SPC_ALIGN$SIZSAM))) {
    stop("A record in the FN123 table has a SPC/GRP combination that is not included in the FN012 table. An FN012 record will need to be added for this SPC/GRP before continuing.")
  }

  # Are all SUBSPACE values associated with a known SPACE?
  SPACE_CHECK <- as.vector(unique(data$FN026_Subspace$SPACE))
  if (any(!(SPACE_CHECK %in% data$FN026$SPACE))) {
    stop("There is a SPACE value in the FN016_Subspace table that does not exist in the FN026 table.")
  }

  # Do all FN121 records have a valid SUBSPACE?
  FN121_SUBSPACE_CHECK <- as.vector(unique(data$FN121$SUBSPACE))
  if (any(!(data$FN121_SUBSPACE_CHECK %in% data$FN026_Subspace$SUBSPACE))) {
    stop("There is a SUBSPACE value in the FN121 table that does not exist in the FN026_Subspace table.")
  }

  # Do all Stream_Dimension records have a valid SUBSPACE?
  SD_SUBSPACE_CHECK <- as.vector(unique(data$Stream_Dimensions$SUBSPACE))
  if (any(!(SD_SUBSPACE_CHECK %in% data$FN026_Subspace$SUBSPACE))) {
    stop("There is a SUBSPACE value in the Stream_Dimensions table that does not exist in the FN026_Subspace table.")
  }

  # Append the data
  populate_db(target, data, verbose)

}
