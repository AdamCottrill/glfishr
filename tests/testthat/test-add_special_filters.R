##' the add_special_filters special filter options to selected endpoints
##'
##' Some of the the api endpoints accept filter arguments that are not
##' captured in the automatically generated swagger doc's.  These need
##' to be added so they can be presented to glfishr users.
##'
##' If new filters are added in the future, test cases should be add
##' here too.

filters <- data.frame(name = character(), description = character())


test_that("unknown endpoint name has no effect ", {
  observed <- add_special_filters("foo", filters)
  expect_equal(observed, filters)
})


test_that("fn121 has filters added for 'mu_type'", {
  observed <- add_special_filters("fn121", filters)
  expect_equal(nrow(observed), 1)
  expect_equal(observed$name, c("mu_type"))
})


test_that("gear has filters added for 'all', 'depreciated', confirmed", {
  observed <- add_special_filters("gear", filters)
  expect_equal(nrow(observed), 3)
  expect_equal(observed$name, c("all", "depreciated", "confirmed"))
})


test_that("fn012_protocol has filters added for 'all', 'active', confirmed", {
  observed <- add_special_filters("fn012_protocol", filters)
  expect_equal(nrow(observed), 3)
  expect_equal(observed$name, c("all", "active", "confirmed"))
})


test_that("prj_ldr has filter added for 'all'", {
  observed <- add_special_filters("prj_ldr", filters)
  expect_equal(nrow(observed), 1)
  expect_equal(observed$name, c("all"))
})


test_that("species has filter added for 'detail'", {
  observed <- add_special_filters("species", filters)
  expect_equal(nrow(observed), 1)
  expect_equal(observed$name, c("detail"))
})
