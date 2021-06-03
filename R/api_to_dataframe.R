##' Given a url submit the request and return the results as a
##' dataframe.
##'
##' Given a url submit the request and return the results as a
##' dataframe. If the response is paginated, the functions is called
##' recursively until all of the pages have been loaded ($next is
##' null). A maximum of 10 requests are made.  If the maximum number
##' of pages is reached, the function returns the data and issues a
##' warning that there may be additional data and that the filters
##' should be refined and multiple requests made and then combined to
##' ensure that all of the records selected by the filter are returned.
##'
##'
##' @param url string
##' @param data dataframe
##' @param page number
##' @param recursive boolean
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return dataframe

api_to_dataframe <- function(url, data = NULL, page = 0, recursive = TRUE) {
  maxPageCount <- 10
  response <- httr::GET(url)
  json <- httr::content(response, "text", encoding = "UTF-8")
  payload <- jsonlite::fromJSON(json, flatten = TRUE)
  page <- page + 1

  if (page > maxPageCount) {
    warning(paste0(
      "The response from the server exceeded the maximum number of api calls and may be incomplete.\n",
      "Verify your filters and consider refining your selection. If you meant to fetch \n",
      "a large number of rows, it may be necessary to submit multiple requests with \n",
      "different filters and combine them in R."
    ))
  }

  if (!is.null(payload[["results"]])) {
    if (is.null(data)) {
      data <- payload$results
    } else {
      data <- rbind(data, payload$results)
    }

    next_url <- payload$`next`
    if (!is.null(next_url) && page < maxPageCount && recursive) {
      data <- api_to_dataframe(next_url, data, page)
    }
    return(data)
  } else {
    data <- payload
  }


  return(data)
}
