#' Populate an Assessment Portal template using the GLIS API
#'
#' This function accesses the API endpoints for the Assessment Portal (FN_Portal)
#' tables of a specified project code and imports these records into a specified
#' template database file. By default, the file path is assumed to be the user's 
#' home directory (typically 'Documents'). An alternate file path can be specified 
#' using the 'alternate_path' option. This function was designed based on the 
#' Great_Lakes_Assessment_Template_5 format. 
#'
#'
#' There are a few important considerations when running this function:
#'  + The Project Code (prj_cd) must be submitted in quotation marks.
#'  
#'  + The 'target' parameter must include the file type in the name (e.g., "DATABASE.accdb").
#'  It must also be submitted in quotation marks.
#'  
#'  + The 'alternate_path' must have all backslashes replaced with forward slashes and
#'  exclude the name of the target database (it will be appended based on 'target'). It
#'  must also be submitted in quotation marks.
#'   
#'  + The 'skip_fn012' provides an option to specify whether the FN011 and FN012 tables 
#'  were completed in the target template database. Setting this option to 'TRUE' will
#'  (1) compare the FN012 table in the template against the FN123 table from GLIS and,
#'  (2) skip the import steps for the FN011 and FN012 tables.
#' 
#'
#' @param prj_cd The Project Code of a project in GLIS.
#' @param target The name of the target template database file. 
#' @param alternate_path An alternative file path for the target template database file.
#' @param skip_fn012 Optional parameter to identify if the FN012 table has been
#' filled-out in the target template database. The default is 'FALSE'. 
#' 
#'
#' @author Arthur Bonsall \email{arthur.bonsall@@ontario.ca}
#' @examples
#'
#' populate_template_assessment("LEA_IA17_097", "Great_Lakes_Assessment_Template_5.accdb")
#' 
#' populate_template_assessment("LEA_IA23_SHA", "IBHN_2023_GLAT5.accdb",
#'  "C:/Users/BonsallAr/OneDrive - Government of Ontario/Documents/Research Programs/Inner Bay Hoopnet")
#' 
#' populate_template_assessment("LEA_IA22_093", "LPBTW_093_2023.accdb", skip_fn012 = TRUE)

populate_template_assessment <- function(prj_cd, target, alternate_path = NULL, skip_fn012 = FALSE) {
  
  #Specify the Project Code
  PROJECT <- toupper(prj_cd)
  
  #Import the FN011 and FN012 if required 
  if(skip_fn012 == FALSE){
    
    FN011 <- get_FN011(list(prj_cd = PROJECT))
    FN012 <- get_FN012(list(prj_cd = PROJECT))
    
    #Quick validation to ensure that the FN012 table is populated.
    #No point in downloading data from GLIS otherwise; it'll just fail at FN123.
    if(is.null(dim(FN012))){stop("The FN012 table is empty and will need to be populated before continuing. After filling out the FN011 and FN012 tables in the template, rerun the function with 'skip_fn012' = TRUE.")}
  }
  
  #Import the data from other tables
  FN022 <- get_FN022(list(prj_cd = PROJECT))
  FN026 <- get_FN026(list(prj_cd = PROJECT))
  FN026_Subspace <- get_FN026_Subspace(list(prj_cd = PROJECT))
  FN028 <- get_FN028(list(prj_cd = PROJECT))
  FN121 <- get_FN121(list(prj_cd = PROJECT))
  FN121_Limno <- get_FN121_Limno(list(prj_cd = PROJECT))
  FN121_Trapnet <- get_FN121_Trapnet(list(prj_cd = PROJECT))
  FN121_Trawl <- get_FN121_Trawl(list(prj_cd = PROJECT))
  FN121_Weather <- get_FN121_Weather(list(prj_cd = PROJECT))
  FN121_Electrofishing <- get_FN121_Electrofishing(list(prj_cd = PROJECT))
  FN122 <- get_FN122(list(prj_cd = PROJECT))
  FN123 <- get_FN123(list(prj_cd = PROJECT))
  FN123_NonFish <- get_FN123_NonFish(list(prj_cd = PROJECT))
  FN124 <- get_FN124(list(prj_cd = PROJECT))
  FN125 <- get_FN125(list(prj_cd = PROJECT))
  FN125_lamprey <- get_FN125_Lamprey(list(prj_cd = PROJECT))
  FN125_tags <- get_FN125_Tags(list(prj_cd = PROJECT))
  FN126 <- get_FN126(list(prj_cd = PROJECT))
  FN127 <- get_FN127(list(prj_cd = PROJECT))
  Stream_Dimensions <- get_Stream_Dimensions(list(prj_cd = PROJECT))
  gear_effort_process_types <- get_gear_process_types()
  
  #FN121_GPS_Tracks <- get_FN121_GPS_Tracks(list(prj_cd = PROJECT))
  
  
  #-------------------------------------------------------------------------
  #Table Adjustments
  
  #FN011
  if(skip_fn012 == FALSE){
    FN011$LAKE = FN011$LAKE.ABBREV
    FN011$PRJ_LDR = paste(FN011$PRJ_LDR.FIRST_NAME, FN011$PRJ_LDR.LAST_NAME)
    FN011 <- subset(FN011, select = -c(PRJ_LDR.USERNAME, PRJ_LDR.FIRST_NAME, PRJ_LDR.LAST_NAME,
                                       LAKE.LAKE_NAME, LAKE.ABBREV))
  }
  
  #FN121
  #This section will add the sub-tables to the FN121 table.
  #The code first checks if the table exists; if it does, the tables are merged.
  #If the table does not exist, the fields are added to the FN121 table manually.
  
  #FN121_Limno
  if(!is.null(dim(FN121_Limno))){FN121 <- merge(FN121, FN121_Limno, all.x = TRUE)}else{
    FN121$O2GR0 <- NA
    FN121$O2GR1 <- NA
    FN121$O2BOT0 <- NA
    FN121$O2BOT1 <- NA
    FN121$O2SURF0 <- NA
    FN121$O2SURF1 <- NA
  }
  
  #FN121_Trapnet
  if(!is.null(dim(FN121_Trapnet))){FN121 <- merge(FN121, FN121_Trapnet, all.x = TRUE)}else{
    FN121$COVER_TYPE <- NA
    FN121$BOTTOM_TYPE <- NA
    FN121$VEGETATION <- NA
    FN121$LEAD_ANGLE <- NA
    FN121$LEADUSE <- NA
    FN121$DISTOFF <- NA
  }
  
  #FN121_Trawl
  if(!is.null(dim(FN121_Trawl))){FN121 <- merge(FN121, FN121_Trawl, all.x = TRUE)}else{
    FN121$VESSEL
    FN121$VESSEL_SPEED
    FN121$VESSEL_DIRECTION
    FN121$WARP
  }
  
  #FN121_Weather
  if(!is.null(dim(FN121_Weather))){FN121 <- merge(FN121, FN121_Weather, all.x = TRUE)}else{
    FN121$AIRTEM0
    FN121$AIRTEM1
    FN121$WIND0
    FN121$WIND1
    FN121$PRECIP0
    FN121$PRECIP1
    FN121$CLOUD_PC0
    FN121$CLOUD_PC1
    FN121$WAVEHT0
    FN121$WAVEHT1
    FN121$XWEATHER
  }
  
  #Minor fixes
  FN121$COVER = FN121$COVER_TYPE
  FN121$BOTTOM = FN121$BOTTOM_TYPE
  FN121 <- subset(FN121, select = -c(SPACE, MANAGEMENT_UNIT, COVER_TYPE, BOTTOM_TYPE))
  
  #FN121_GPS_Tracks
  
  #FN125
  FN125 <- subset(FN125, select = -c(AGE))
  
  #Gear_Effort_Process_Types
  Gear_Effort_Process_Types <- merge(FN121, FN122, all.x = TRUE, all.y = TRUE)
  Gear_Effort_Process_Types <- merge(Gear_Effort_Process_Types, FN028, all.x = TRUE)
  Gear_Effort_Process_Types <- subset(Gear_Effort_Process_Types, select = c(GR, EFF, PROCESS_TYPE))
  Gear_Effort_Process_Types <- unique(Gear_Effort_Process_Types)
  Gear_Effort_Process_Types <- merge(Gear_Effort_Process_Types, gear_effort_process_types)
  
  #Stream_Dimensions
  if(!is.null(dim(Stream_Dimensions))){Stream_Dimensions <- subset(Stream_Dimensions, select = -c(SPACE))}
  
  #-------------------------------------------------------------------------
  #Table Relationship Validation
  
  #Requires import of FN012 data from the template if skip_fn012 == TRUE
  if(skip_fn012 == TRUE){
    
    if(is.null(alternate_path)){
      IMPORT <- RODBC::odbcDriverConnect(paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", path.expand('~'), "/", target))
    }else{
      IMPORT <- RODBC::odbcDriverConnect(paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", alternate_path, "/", target))
    }
    FN012 <- RODBC::sqlFetch(IMPORT, "FN012", as.is = TRUE)
    RODBC::odbcClose(IMPORT)
  }
  
  #Are all SPC values in FN123 also in FN012?
  SPC_ALIGN <- subset(FN123, select = c(PRJ_CD, SPC, GRP))
  SPC_ALIGN <- unique(SPC_ALIGN)
  SPC_ALIGN <- merge(SPC_ALIGN, FN012, all.x = TRUE)
  if(any(is.na(SPC_ALIGN$SIZSAM))){stop("A record in the FN123 table has a SPC/GRP combination that is not included in the FN012 table. An FN012 record will need to be added for this SPC/GRP before continuing.")}
  
  #Are all SUBSPACE values associated with a known SPACE?
  SPACE_CHECK <- as.vector(unique(FN026_Subspace$SPACE))
  if(any(!(SPACE_CHECK %in% FN026$SPACE))){stop("There is a SPACE value in the FN016_Subspace table that does not exist in the FN026 table.")}
  
  #Do all FN121 records have a valid SUBSPACE?
  FN121_SUBSPACE_CHECK <- as.vector(unique(FN121$SUBSPACE))
  if(any(!(FN121_SUBSPACE_CHECK %in% FN026_Subspace$SUBSPACE))){stop("There is a SUBSPACE value in the FN121 table that does not exist in the FN016_Subspace table.")}
  
  #Do all Stream_Dimension records have a valid SUBSPACE? 
  SD_SUBSPACE_CHECK <- as.vector(unique(Stream_Dimensions$SUBSPACE))
  if(any(!(SD_SUBSPACE_CHECK %in% FN026_Subspace$SUBSPACE))){stop("There is a SUBSPACE value in the Stream_Dimensions table that does not exist in the FN016_Subspace table.")}
  
  
  #-------------------------------------------------------------------------
  
  #Open the target dataset
  if(is.null(alternate_path)){
    TARGET <- RODBC::odbcDriverConnect(paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", path.expand('~'), "/", target))
  }else{
    TARGET <- RODBC::odbcDriverConnect(paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", alternate_path, "/", target))
  }
  
  #Append the data
  #Excludes FN011 and FN012 if skip_fn012 == TRUE
  #All tables below FN122 will also be checked to ensure that the dataframe exists
  
  if(skip_fn012 == FALSE){
    RODBC::sqlSave(TARGET, FN011, append = TRUE, rownames = FALSE)
    RODBC::sqlSave(TARGET, FN012, append = TRUE, rownames = FALSE)
  }
  
  RODBC::sqlSave(TARGET, FN022, append = TRUE, rownames = FALSE)
  RODBC::sqlSave(TARGET, FN026, append = TRUE, rownames = FALSE)
  RODBC::sqlSave(TARGET, FN026_Subspace, append = TRUE, rownames = FALSE)
  RODBC::sqlSave(TARGET, FN028, append = TRUE, rownames = FALSE)
  RODBC::sqlSave(TARGET, FN121, append = TRUE, rownames = FALSE)
  if(!is.null(dim(FN121_Electrofishing))){RODBC::sqlSave(TARGET, FN121_Electrofishing, append = TRUE, rownames = FALSE)}
  RODBC::sqlSave(TARGET, FN122, append = TRUE, rownames = FALSE)
  if(!is.null(dim(FN123))){RODBC::sqlSave(TARGET, FN123, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN123_NonFish))){RODBC::sqlSave(TARGET, FN123_NonFish, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN124))){RODBC::sqlSave(TARGET, FN124, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN125))){RODBC::sqlSave(TARGET, FN125, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN125_lamprey))){RODBC::sqlSave(TARGET, FN125_lamprey, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN125_tags))){RODBC::sqlSave(TARGET, FN125_tags, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(FN126))){suppressWarnings(RODBC::sqlSave(TARGET, FN126, append = TRUE, rownames = FALSE))}
  if(!is.null(dim(FN127))){RODBC::sqlSave(TARGET, FN127, append = TRUE, rownames = FALSE)}
  if(!is.null(dim(Stream_Dimensions))){RODBC::sqlSave(TARGET, Stream_Dimensions, append = TRUE, rownames = FALSE)}
  RODBC::sqlSave(TARGET, Gear_Effort_Process_Types, append = TRUE, rownames = FALSE)
  
  #RODBC::sqlSave(TARGET, FN121_GPS_Tracks, append = TRUE, rownames = FALSE)
  
  RODBC::odbcClose(TARGET)
}