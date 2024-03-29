% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_pt_files.R
\name{download_pt_files}
\alias{download_pt_files}
\title{download_pt_files - Download reports or associated files from
project tracker}
\usage{
download_pt_files(
  file_list,
  target_dir,
  xlsx_toc = "reports_toc.xlsx",
  create_target_dir = TRUE
)
}
\arguments{
\item{file_list}{dataframe - containing the contents to be written
into the toc. The last column of which is expected to be the path
the report or associated file on project tracker.}

\item{target_dir}{string - the directory where the files will be
copied}

\item{xlsx_toc}{the name of the excel table of contents file to be
created in the target directory.  A toc is only produced if this
argument ends in 'xlsx'.}

\item{create_target_dir}{boolean should the target directory be
created if it does not already exist}
}
\value{
dataframe
}
\description{
This is a utility function that is used by both fetch_pt_reports()
and fetch_pt_associated_files() to actually download the files they
return. The download logic is sufficiently similar for both
function that it makes to encapsulate it in a single helper
function.  This function takes a dataframe that contains a list of
reports or associated file name/path. The file name must be the
last column in the data frame.  Each report or file listed in the
dataframe is downloaded into the target directory. If
create_target_dir is True, and the target directory does not exist
it will be created. If xlsx_toc is true, an associated xlsx file
will be created in the target directory - the spreadsheet will
contain all of the fields contained in the file list, and a
hyperlink to each of the downloaded files.
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
