#' fetch_pt_reports - Project Tracker Reports
#'
#' This function accesses the api endpoint to for associated files that have
#' been uploaded to project tracker.  This api endpoint accepts a
#' large number of filters associated with the project or report type.
#' Project specific filters include project code(s), years, lakes, and
#' project lead.  Reports can also be filtered by their associated
#' milestone.  Valid report types are: "Prj Prop", "Prj Prop Pres",
#' "procvallog", "ProjDescPres", "Prj Desc", "Protocol",
#' "Field Report", "Prj Comp Rep", "Prj Comp Pres", "Sum Rep", and
#' "Creel Estimates" . Use 'show_filter("reports")' to see the full list
#' of available filters.  This function returns a dataframe containing
#' attributes of the report, including project code, report type, and
#' the path to the report on the server. It is often uses in
#' conjunction with [fetch_pt_reports()] to actually download the
#' selected reports to a target directory.
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
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @seealso [fetch_pt_reports()]
#' @examples
#' \donttest{
#' reports <- fetch_pt_reports(list(
#'   lake = "ON", year__gte = 2012,
#'   year__lte = 2018
#' ))
#'
#' reports <- fetch_pt_reports(list(
#'   lake = "HU", year__gte = 2012,
#'   prj_cd__like = "006", report_type = "prtocol"
#' ))
#'
#' reports <- fetch_pt_reports(list(lake = "ER", protocol = "TWL"))
#'
#' filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
#' reports <- fetch_pt_reports(filters)
#'
#' reports <- fetch_pt_reports(list(lake = "HU", protocol = "USA"))
#' }
#'
fetch_pt_reports <- function(filter_list, target_dir,
                             xlsx_toc = "report_toc.xlsx",
                             create_target_dir = TRUE) {
  reports <- get_pt_reports(filter_list)
  reports <- subset(reports,
    reports$CURRENT == TRUE,
    select = c("PRJ_CD", "PRJ_NM", "REPORT_TYPE", "REPORT_PATH")
  )

  download_pt_files(reports, target_dir, xlsx_toc, create_target_dir)
}
