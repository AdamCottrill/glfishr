test_that("get_sc_portal_root return the url for glis creel api", {
  domain <- get_domain()
  expected <- sprintf("%screels/api/v1", domain)
  expect_equal(get_sc_portal_root(), expected)
})
