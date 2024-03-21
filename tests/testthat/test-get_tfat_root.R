test_that("get_tfat_root return the url for glis tfat api", {
  domain <- get_domain()
  domain <- gsub("intra.glis", "intra.dev.glis", domain)
  expected <- sprintf("%stfat/api/v1", domain)
  expect_equal(get_tfat_root(), expected)
})
