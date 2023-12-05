test_that("get_pt_portal_root return the url for glis project tracker api", {
  domain <- get_domain()
  expected <- sprintf("%sproject_tracker/api/v1", domain)
  expect_equal(get_pt_portal_root(), expected)
})
