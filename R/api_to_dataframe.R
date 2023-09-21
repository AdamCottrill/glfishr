#' Given a url submit the request and return the results as a
#' dataframe.
#'
#' Given a url submit the request and return the results as a
#' dataframe. If the response is paginated, the functions is called
#' recursively until all of the pages have been loaded ($next is
#' null). A maximum of 50 requests are made.  If the maximum number
#' of pages is reached, the function returns the data and issues a
#' warning that there may be additional data and that the filters
#' should be refined and multiple requests made and then combined to
#' ensure that all of the records selected by the filter are returned.
#'
#'
#' @param url string
#' @param data dataframe
#' @param page number
#' @param recursive boolean
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe


api_to_dataframe <- function(url, data = NULL, page = 0, recursive = TRUE) {
  if (!exists("token")) token <- get_token()
  
  auth_header <- sprintf("Token %s", token)
  
  max_page_count <- 50
  url <- gsub("\\n", " ", url)
  url <- utils::URLencode(url)
  # response <- tryCatch(httr::GET(url),
  response <- tryCatch(httr::GET(url, httr::add_headers(authorization = auth_header)),
                       error = function(err) {
                         print("unable to fetch from the server. Is your VPN active?")
                       }
  )
  
  json <- httr::content(response, "text", encoding = "UTF-8")
  
  payload <- tryCatch(
    jsonlite::fromJSON(json, flatten = TRUE),
    error = function(err) {
      print("unable able to parse the json response from:")
      print(url)
      return(list(paths = list()))
    }
  )
  
  page <- page + 1
  
  if (page >= max_page_count) {
    warning(paste0(
      "The response from the server exceeded the maximum number of api \n",
      "calls and may be incomplete. Verify your filters and consider  \n",
      "refining your selection. If you meant to fetch a large number of  \n",
      "rows, it may be necessary to submit  multiple requests with \n",
      "different filters and combine them in R."
    ))
  }
  
  if (is.null(token[["token"]])) {
    warning(paste0(
      "Your token was not retrieved successfully and some data may be hidden. \n",
      "Run get_token() to re-enter your credentials."
    ))
  }
  
  if (!is.null(payload[["results"]])) {
    if (is.null(data)) {
      data <- payload$results
    } else {
      data <- rbind(data, payload$results)
    }
    next_url <- payload$`next`
    if (!is.null(next_url) && page < max_page_count && recursive) {
      data <- api_to_dataframe(next_url, data, page)
    }
    return(data)
  } else {
    data <- payload
  }
  
  
  return(data)
}
