test_that("get_swagger_url works for known apps", {
  known_apps <- c(
    "common",
    "project_tracker",
    "fn_portal",
    "creels"
  )

  domain <- get_domain()

  for (app in known_apps) {
    expected <- sprintf("%s%s/api/v1/swagger.json", domain, app)
    observed <- get_swagger_url(app)
    expect_equal(expected, observed)
  }
})


test_that("get_swagger_url throws an error for unknown apps", {
  expect_error(get_swagger_url("foo"), "'arg' should be one of")
})
