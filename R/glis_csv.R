#' Fetch and Read csv files from glis
#'
#' This function takes a path from a csv file that has been uploaded
#' GLIS and reads it into a data frame.  To read files directly from
#' glis using R, requires a user token.  If a token is available in
#' the current R session it will be used, otherwise a new token will
#' be generated.  The function's argument is a string that represents
#' the last part of the download url for the target file.  This is
#' consistent with the FILE_PATH attribute of records returned by the
#' ~get_pt_associated_files()~ function.  Alternatively, the complete
#' file path including the domain and complete url is also valid.
#'
#' @param filepath string
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' # it is possible to fetch the list of files using the glfishr
#' # function:
#' files <- get_pt_associated_files(list(prj_cd = "LHA_IA24_116"))
#' # you might have ot filter the path objects to ensure they are the correct csv's
#'
#' csv_url <- files[1, ]$FILE_PATH
#' xlymph_data <- glis_csv(csv_url)
#' head(xlymph_data)
#' # or
#' csv_url <- files[2, ]$FILE_PATH
#' file2 <- glis_csv(csv_url)
#' head(file2)
#'
#' #----------------------------#'
#' # OR
#'
#' # first right on the link provided in the details page and select
#' # "Copy link address" from the pop-up menu and paste it here:
#' csv_url <- paste0(
#'   "https://intra.glis.mnr.gov.on.ca/project_tracker/",
#'   "serve_file/associated_files/LHA_IA24_116/LHA_IA24_116-XLYMPH.csv"
#' )
#'
#' # then pass that url to the  glis_csv() function
#' csv_data <- glis_csv(csv_url)
glis_csv <- function(filepath) {
  if (!grepl("\\.csv$", filepath)) {
    stop("only csv files are supported!")
  }

  auth_header <- get_auth_header()

  glis_serve_file_url <- "https://intra.glis.mnr.gov.on.ca/project_tracker/serve_file/"
  filepath <- gsub(glis_serve_file_url, "", filepath)

  url <- paste0(glis_serve_file_url, filepath)
  url <- utils::URLencode(url)

  response <- get_request(url, auth_header)
  content <- httr::content(response, "text", encoding = "UTF-8")

  # if the response indicates that there is an error - try again.
  # it never seems to work the first time it is used in a session.
  if (grepl("<title>Sign in to your account</title>", content)) {
    response <- get_request(url, auth_header)
    content <- httr::content(response, "text", encoding = "UTF-8")
  }

  # Check if the request was successful
  if (httr::http_status(response)$category == "Success") {
    data <- utils::read.csv(
      text = content,
      stringsAsFactors = FALSE,
      colClasses = "character"
    )
    return(data)
  } else {
    print("Failed to retrieve data. Check your credentials and the URL.")
    print(httr::http_status(response))
  }
}
