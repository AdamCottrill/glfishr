test_that("fn122 slug is trimmed to fn121", {
  slug_in <- "lha_ia10_006-111-1"
  slug_out <- "lha_ia10_006-111"
  expect_equal(truncate_slug(slug_in), slug_out)
})


test_that("fn126 slug is trimmed to fn125", {
  slug_in <- "lha_ia10_006-111-1-091-00-1-6"
  slug_out <- "lha_ia10_006-111-1-091-00-1"
  expect_equal(truncate_slug(slug_in), slug_out)
})


test_that("fn126 slug is trimmed to fn125 with levels", {
  slug_in <- "lha_ia10_006-111-1-091-00-1-6"
  slug_out <- "lha_ia10_006-111-1-091-00-1"
  expect_equal(truncate_slug(slug_in, 1), slug_out)
})


test_that("fn125 slug can trimmed to fn122 with levels argument", {
  slug_in <- "lha_ia10_006-111-051-091-00-1"
  slug_out <- "lha_ia10_006-111-051"
  expect_equal(truncate_slug(slug_in, 3), slug_out)
})
