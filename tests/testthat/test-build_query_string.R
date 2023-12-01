# the build query function takes a named list of attributes that are
# to be used to filter an api endpoint. Thhese tests confirm that the
# function works as expected.


test_that("empty list return empty query string", {
  filters = list()
  expected = ""
  expect_equal(build_query_string(filters), expected)
})



test_that("single value returned as key-value pair", {
  filters = list(lake = "HU")
  expected = "?lake=HU"
  expect_equal(build_query_string(filters), expected)
})


test_that("vector of values concetnated as csv", {
  filters = list(lake = c("HU", "ER"))
  expected = "?lake=HU,ER"
  expect_equal(build_query_string(filters), expected)
})


test_that("multiple keys present as multiple key-value pairs", {
  filters = list(lake="HU", year=2020)
  expected = "?lake=HU&year=2020"
  expect_equal(build_query_string(filters), expected)
})
