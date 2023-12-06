with_mock_api({
  test_that("success message appears if token can be retrieved", {
    # set the GLIS domain so the real url is used (and intercepted by httptest)
    withr::local_envvar(c(
      "GLIS_DOMAIN" = "",
      "GLIS_USERNAME" = "Homer",
      "GLIS_PASSWORD" = "123-donuts"
    ))
    expect_message(
      returned_token <- get_token(),
      "You have been successfully authenticated on the GLIS server."
    )
    # the global token should be populated
    expect_false(is.null(token))
  })
})

with_mock_api({
  test_that("warning message is returned if a token could not be retreived",
  {
    # set the GLIS domain so the real url is used (and intercepted by httptest)
    withr::local_envvar(c(
      "GLIS_DOMAIN" = "",
      "GLIS_USERNAME" = "Homer",
      "GLIS_PASSWORD" = "WRONG password"
    ))

    expect_warning(
      returned_token <- get_token(),
      "Unable to log in with provided credentials."
    )
    # the global token should NOT be populated
    expect_null(token)
  })
})
