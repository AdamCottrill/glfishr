#' fetch_pt_reports - Project Tracker Reports
#'
#' This function accesses the api endpoint for files associated with core reporting
#' requirements that have been uploaded to project tracker.  This api endpoint accepts a
#' large number of filters associated with the project or report type.
#' Project specific filters include project code(s), years, lakes, and
#' project lead.  Reports can also be filtered by their associated
#' milestone.  Valid report types are: "Prj Prop", "Prj Prop Pres",
#' "procvallog", "ProjDescPres", "Prj Desc", "Protocol",
#' "Field Report", "Prj Comp Rep", "Prj Comp Pres", "Sum Rep", and
#' "Creel Estimates". Use \code{show_filters("reports")} to see the full list
#' of available filters.  This function is used to download selected files
#' to a specified target directory.  It is often used in
#' conjunction with [get_pt_reports()] which returns
#' a dataframe containing attributes of the upload files.
#'
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
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @seealso [fetch_pt_reports()]
#' @examples
#' \dontrun{
#' reports <- fetch_pt_reports(
#'   list(
#'     lake = "ON",
#'     year__gte = 2018,
#'     year__lte = 2019
#'   ),
#'   target_dir = "~/Target-Folder-Name"
#' )
#'
#' reports <- fetch_pt_reports(
#'   list(
#'     lake = "HU",
#'     year__gte = 2018,
#'     prj_cd__like = "006",
#'     report_type = "Protocol"
#'   ),
#'   target_dir = "~/<Target-Folder-Name>"
#' )
#'
#' reports <- fetch_pt_reports(
#'   list(
#'     lake = "ER",
#'     year__gte = 2018,
#'     protocol = "TWL"
#'   ),
#'   target_dir = "~/Target-Folder-Name"
#' )
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' reports <- fetch_pt_reports(filters,
#'   target_dir = "~/Target-Folder-Name"
#' )
#'
#' reports <- fetch_pt_reports(list(lake = "HU", protocol = "USA"))
#'
#' reports <- fetch_pt_reports(
#'   list(lake = "HU", protocol = "USA", year__gte = 2018),
#'   target_dir = "~/<Target-Folder-Name>"
#' )
#' }
#'
fetch_pt_reports <- function(filter_list,
                             target_dir,
                             xlsx_toc = "report_toc.xlsx",
                             create_target_dir = TRUE) {
  reports <- get_pt_reports(filter_list)
  if (length(reports)) {
    reports <- subset(reports,
      reports$CURRENT == TRUE,
      select = c("PRJ_CD", "PRJ_NM", "REPORT_TYPE", "REPORT_PATH")
    )
    download_pt_files(reports, target_dir, xlsx_toc, create_target_dir)
  }
}
