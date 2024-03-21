stub_swagger <- function(endpoint_names) {
  # a helper function to create a minimal nested list that emulates
  # the deeply nested list returned by swager payload - this list has
  # only those attibutes need for filters.

  parameters <- data.frame(
    name = c("year", "prj_cd"),
    # in = c("query", "query"),
    description = c("multiple values", "multiple values"),
    type = c("string", "string"),
    required = c(FALSE, FALSE)
  )


  stub <- list()
  for (endpoint in endpoint_names) {
    stub$paths[[endpoint]]$get$parameters <- parameters
  }
  return(stub)
}

test_that("multiplication works", {
  endpoint_names <- c("/foo/", "/bar/")
  payload <- stub_swagger(endpoint_names)
  observed <- parse_swagger_payload(payload)

  expect_length(observed, 2)
  expect_equal(names(observed), c("foo", "bar"))
  expect_equal(names(observed$foo), c("name", "description"))
  expect_equal(observed$foo$name, c("year", "prj_cd"))
})
