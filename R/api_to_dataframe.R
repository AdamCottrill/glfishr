#' Given a url submit the request and return the results as a
#' dataframe.
#'
#' Given a url submit the request and return the results as a
#' dataframe. If the response is paginated, the functions is called
#' recursively until all of the pages have been loaded ($next is
#' null). A maximum of 20 requests are made.  If the maximum number of
#' pages is reached, the function returns the data and issues a
#' warning that there may be additional data and that the filters
#' should be refined and multiple requests made and then combined to
#' ensure that all of the records selected by the filter are returned.
#' It is generally considered best practice to only request the data
#' needed for your particular analysis by applying appropriate filters
#' to the request than fetch everything and filtering on the client
#' (e.g. R).
#'
#'
#' @param url string
#'
#' @param data dataframe
#'
#' @param page number
#'
#' @param recursive boolean
#'
#' @param request_type string - http request type "GET"" or "POST"
#'
#' @param request_body list, dataframe, or character string to be sent
#'   to the server as the body of the POST request.  Not used in GET
#'   requests.
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe


api_to_dataframe <- function(url, data = NULL, page = 0,
                             recursive = TRUE, request_type = "GET", request_body = NULL,
                             record_count = FALSE) {
  if (!exists("token")) get_token()

  if (is.null(token)) {
    warning(paste0(
      "Your token was not retrieved successfully and some data may be hidden. \n",
      "Run get_token() to re-enter your credentials."
    ))
  }

  auth_header <- sprintf("Token %s", token)

  max_page_count <- 20
  url <- gsub("\\n", " ", url)
  url <- utils::URLencode(url)

  if (request_type == "POST") {
    response <- tryCatch(
      httr::POST(url,
        config = httr::add_headers(authorization = auth_header),
        body = request_body,
        encode = "json"
      ),
      error =
        function(err) {
          print("unable to POST to the server. Is your VPN active?")
        }
    )
  } else {
    response <- tryCatch(
      httr::GET(url,
        config = httr::add_headers(authorization = auth_header)
      ),
      error = function(err) {
        print("unable to fetch from the server. Is your VPN active?")
      }
    )
  }

  json <- httr::content(response, "text", encoding = "UTF-8")

  payload <- tryCatch(
    jsonlite::fromJSON(json, flatten = TRUE),
    error = function(err) {
      print("unable able to parse the json response from:")
      print(url)
      return(list(paths = list()))
    }
  )

  # if the response is paginaged, it will contain a count property,
  # otherwise we have to count the number of objects ourselves
  if (record_count) {
    if (!is.null(payload[["count"]])) {
      return(payload[["count"]])
    } else {
      return(nrow(payload))
    }
  }

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

  if (!is.null(payload[["results"]])) {
    if (is.null(data)) {
      data <- payload$results
    } else {
      data <- rbind(data, payload$results)
    }
    next_url <- payload$`next`
    if (!is.null(next_url) && page < max_page_count && recursive) {
      data <- api_to_dataframe(next_url, data, page, record_count = record_count)
    }
    return(data)
  } else {
    data <- payload
  }


  return(data)
}
