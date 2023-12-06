# the get_domain function should return the production url for GLIS,
# unless the local environment variable GLIS_DOMIAIN has been set to
# alternative value.

# *NOTE* the first test will have to be updated if the production url
# for GLIS ever changes.

test_that("get_domain return current glis domain", {
  # to get test to pass during check:
  if (Sys.getenv("GLIS_DOMAIN") != "") {
    expected <- Sys.getenv("GLIS_DOMAIN")
  } else {
    expected <- "https://intra.glis.mnr.gov.on.ca/"
  }

  observed <- get_domain()
  expect_equal(observed, expected)
})


test_that("get_domain returns value of environ variable if set", {
  expected <- "http://127.0.0.1:8000/"
  withr::local_envvar(c("GLIS_DOMAIN" = expected))
  observed <- get_domain()
  expect_equal(observed, expected)
})
