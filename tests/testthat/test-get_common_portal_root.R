test_that("get_common_portal_root return the url for glis common api", {
  domain <- get_domain()
  expected <- sprintf("%scommon/api/v1", domain)
  expect_equal(get_common_portal_root(), expected)
})
