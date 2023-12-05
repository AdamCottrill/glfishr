test_that("get_fn_portal_root return the url for glis fn api", {
  domain <- get_domain()
  expected <- sprintf("%sfn_portal/api/v1", domain)
  expect_equal(get_fn_portal_root(), expected)
})
