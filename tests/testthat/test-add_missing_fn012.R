# the add missing_012 function ensures that there are fn012 records
# for every unique combination of fn123 PRJ_CD-SPC-GRP


# fn123 == fn012
# fn123 is empty
# duplicate records in  fn123 PRJ_CD-SPC-GRP removed
# extra fn123 added to fn012
# extra fn012 remain ()


prj_cds <- c(
  "LEM_SC18_SCR",
  "LEM_SC18_SCR",
  "LEM_SC18_SCR",
  "LEM_SC18_SCR",
  "LEM_SC18_SCR",
  "LEM_SC18_SCR"
)

spcs <- c(
  "076",
  "316",
  "371",
  "331",
  "302",
  "334"
)

grps <- c(
  "00",
  "00",
  "00",
  "00",
  "00",
  "00"
)

fn012_in <- data.frame(PRJ_CD = prj_cds, SPC = spcs, GRP = grps)
fn123_in <- data.frame(PRJ_CD = prj_cds, SPC = spcs, GRP = grps)


test_that("no change when fn012 and fn123 are equal", {
  observed <- add_missing_fn012(fn012_in, fn123_in)
  expect_equal(observed, fn012_in)
})


test_that("no change when fn123 is empty", {
  observed <- add_missing_fn012(fn012_in, list())
  expect_equal(observed, fn012_in)
})


test_that("extra fn123 records are added to observed", {
  fn123_in <- rbind(fn123_in, data.frame(
    PRJ_CD = "LHA_IA09_002",
    SPC = "091",
    GRP = "10"
  ))
  observed <- add_missing_fn012(fn012_in, fn123_in)

  expected <- with(fn123_in, fn123_in[order(PRJ_CD, SPC, GRP), ])
  rownames(expected) <- NULL

  expect_equal(observed, expected)
})



test_that("no change when fn012 has extra rows", {
  fn012_in <- rbind(fn012_in, data.frame(
    PRJ_CD = "LHA_IA09_002",
    SPC = "091",
    GRP = "10"
  ))

  observed <- add_missing_fn012(fn012_in, fn123_in)

  expect_equal(observed, fn012_in)
})

test_that("duplicate fn123 values are not repeated in fn012", {
  fn123_in <- rbind(fn123_in, fn123_in)
  observed <- add_missing_fn012(fn012_in, fn123_in)
  expect_equal(observed, fn012_in)
})



test_that("extra_columns in fn123 ignored", {
  fn123_in$EXTRA <- "FOO"
  fn012_out <- add_missing_fn012(fn012_in, fn123_in)

  expect_equal(fn012_out, fn012_in)
})


test_that("extra_columns in fn012 perserved", {
  fn012_in$EXTRA <- "FOO"
  fn012_out <- add_missing_fn012(fn012_in, fn123_in)
  expect_equal(fn012_out, fn012_in)
})
