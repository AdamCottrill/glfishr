#' fetch_pt_associated_files - Project Tracker Reports
#'
#' This function accesses the api endpoint for associated files that have
#' been uploaded to project tracker.  This api endpoint accepts a
#' large number of filters associated with the project.
#' Project specific filters include project code(s), years, lakes, and
#' project lead.  Use 'show_filters("associated_files")' to see the full list
#' of available filters.  This function is used to download any files in the
#' associated files section of project tracker to a specified target directory.
#' It is often used in conjunction with [get_pt_associated_files()] which returns
#' a dataframe containing attributes of the upload files.
#'
#' @param filter_list list - the filters used to select the projects
#' and reports to be downloaded from the server.
#'
#' @param target_dir string - the directory where the files will be
#' copied
#'
#' @param xlsx_toc the name of the excel table of contents file to be
#' created in the target directory.  A toc is only produced if this
#' argument ends in 'xlsx'.
#'
#' @param create_target_dir boolean should the target directory be
#' created if it does not already exist
#'
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @seealso [get_pt_associated_files()]
#' @examples
#' \donttest{
#' reports <- fetch_pt_associated_files(list(
#'   lake = "ON", year__gte = 2012,
#'   year__lte = 2018),
#'   target_dir = '~/Target Folder Name')
#'
#' reports <- fetch_pt_associated_files(list(
#'   lake = "HU", year__gte = 2012,
#'   prj_cd__like = "006"),
#'   target_dir = '~/Target Folder Name')
#'
#' reports <- fetch_pt_associated_files(list(lake = "ER", protocol = "TWL"), target_dir = '~/Target Folder Name')
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' reports <- fetch_pt_associated_files(filters, target_dir = '~/Target Folder Name')
#'
#' reports <- fetch_pt_associated_files(list(lake = "HU", protocol = "USA"), target_dir = '~/Target Folder Name')
#' }
#'
fetch_pt_associated_files <- function(filter_list, target_dir,
                                      xlsx_toc = TRUE,
                                      create_target_dir = TRUE) {
  files <- get_pt_associated_files(filter_list)
  files <- subset(files,
    files$CURRENT == TRUE,
    select = c("PRJ_CD", "FILE_PATH")
  )
  download_pt_files(files, target_dir, xlsx_toc, create_target_dir)
}
