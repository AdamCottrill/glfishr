test_that("credentials are returned if both username and password are defined", {
  username <- "simpsonhomer"
  password <- "123-donuts"

  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  observed <- get_credentials()

  expected <- list(
    username = username,
    password = password
  )
  expect_equal(expected, observed)
})


test_that("warning message is presented if both username and password are missing - rstudioapi", {
  username <- ""
  password <- ""
  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "rstudioapi::showPrompt", "dummy value")
  mockery::stub(get_credentials, "rstudioapi::askForPassword", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})


test_that("warning message is presented if GLIS_USERNAME is  missing - rstudioapi", {
  username <- ""
  password <- "123-donuts"

  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "rstudioapi::showPrompt", "dummy value")
  mockery::stub(get_credentials, "rstudioapi::askForPassword", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})


test_that("warning message is presented if GLIS_PASSWORD is missing - rstudioapi", {
  username <- "simpsonhomer"
  password <- ""

  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "rstudioapi::showPrompt", "dummy value")
  mockery::stub(get_credentials, "rstudioapi::askForPassword", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})


# ===============================
# these three tests use the fallback readline function for
# authentication rather than rstudioapi.

test_that("warning message is presented if both username and password are missing - readline", {
  username <- ""
  password <- ""
  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "readline", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})


test_that("warning message is presented if GLIS_USERNAME is  missing - readline", {
  username <- ""
  password <- "123-donuts"

  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "readline", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})


test_that("warning message is presented if GLIS_PASSWORD is missing - readline", {
  username <- "simpsonhomer"
  password <- ""

  withr::local_envvar(c("GLIS_USERNAME" = username, "GLIS_PASSWORD" = password))

  mockery::stub(get_credentials, "readline", "dummy value")

  expect_message(
    observed <- get_credentials(),
    "Consider defining environment variables 'GLIS_USERNAME' and  "
  )
})
