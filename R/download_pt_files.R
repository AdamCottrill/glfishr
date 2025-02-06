#' download_pt_files - Download reports or associated files from
#' project tracker
#'
#' This is a utility function that is used by both fetch_pt_reports()
#' and fetch_pt_associated_files() to actually download the files they
#' return. The download logic is sufficiently similar for both
#' function that it makes to encapsulate it in a single helper
#' function.  This function takes a dataframe that contains a list of
#' reports or associated file name/path. The file name must be the
#' last column in the data frame.  Each report or file listed in the
#' dataframe is downloaded into the target directory. If
#' create_target_dir is True, and the target directory does not exist
#' it will be created. If xlsx_toc is true, an associated xlsx file
#' will be created in the target directory - the spreadsheet will
#' contain all of the fields contained in the file list, and a
#' hyperlink to each of the downloaded files.
#'
#' @param file_list dataframe - containing the contents to be written
#' into the toc. The last column of which is expected to be the path
#' the report or associated file on project tracker.
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
#'
#'
download_pt_files <- function(file_list, target_dir,
                              xlsx_toc = "reports_toc.xlsx",
                              create_target_dir = TRUE) {
  if (missing(target_dir)) {
    stop("a target directory was not provided")
  }

  if (!dir.exists(target_dir)) {
    if (create_target_dir) {
      dir.create(target_dir, showWarnings = FALSE)
    } else {
      stop(sprintf(
        paste0(
          "The target directory (%s) does not exist.",
          " Would you like to create it?"
        ),
        target_dir
      ))
    }
  }

  # root url of azure blob storage created by LRC.  If it ever
  # changes, this path have to be updated accordingly
  BLOB_ROOT <- "https://glis0000prd0420ggt3.blob.core.windows.net/media/"

  for (i in seq(nrow(file_list))) {
    filename <- paste0(
      # get_domain(),
      # "project_tracker/serve_file/",
      BLOB_ROOT,
      file_list[, ncol(file_list)][i]
    )
    print(sprintf("downloading %s", filename))
    trg <- file.path(target_dir, basename(filename))
    utils::download.file(filename, trg, mode = "wb")
  }

  if (grepl("\\.xlsx$", xlsx_toc)) {
    link_col <- ncol(file_list)
    link_style <- openxlsx::createStyle(
      fontColour = "blue",
      textDecoration = c("underline")
    )
    file_list[, ncol(file_list)] <- sprintf(
      '=HYPERLINK("%s","%s")',
      basename(file_list[, link_col]),
      basename(file_list[, link_col])
    )
    class(file_list[, ncol(file_list)]) <- "formula"

    wb <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, "Files")
    openxlsx::writeData(wb, sheet = 1, x = file_list)
    openxlsx::addStyle(wb, "Files", link_style,
      rows = 2:(1 + nrow(file_list)), cols = link_col
    )
    xlsx_file <- file.path(target_dir, xlsx_toc)
    openxlsx::saveWorkbook(wb, xlsx_file, overwrite = TRUE)
    print(paste0("Done. See:  ", xlsx_file))
  }
}
