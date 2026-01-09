# the assign fn012_sizsam function takes an fn012 table, an fn124 and
# an fn125 table. If a PRJ_CD-SPC-GRP comination occures in the FN124
# table

# | FN012.SIZSAM | FN124 | FN125 |
# |--------------+-------+-------|
# |            0 | -     | -     |
# |            1 | -     | Y     |
# |            2 | Y     | -     |
# |            3 | Y     | Y     |

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


fn012_in <- data.frame(PRJ_CD = prj_cds, GRP = grps, SPC = spcs, SIZSAM = 0)
fn124 <- data.frame(PRJ_CD = prj_cds, GRP = grps, SPC = spcs)
fn125 <- data.frame(PRJ_CD = prj_cds, GRP = grps, SPC = spcs)

test_that("no change to fn012 when fn124 and fn125 are empty lists", {
  fn124 <- list()
  fn125 <- list()
  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expect_equal(fn012_out, fn012_in)
})


test_that("no change to fn012 when fn124 and fn125 are empty dataframes", {
  fn124$PRJ_CD <- "X"
  fn125$PRJ_CD <- "X"

  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expect_equal(fn012_out, fn012_in)
})


test_that("sizsam updated to 3 both fn124 and fn125", {
  fn124$GRP[c(5, 6)] <- "10"
  fn125$GRP[c(5, 6)] <- "10"

  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expected <- c(3, 3, 3, 3, 0, 0)

  expect_equal(fn012_out$SIZSAM, expected)
})


test_that("sizsam updated to 2 if just fn124", {
  fn124$GRP[c(5, 6)] <- "10"
  fn125$PRJ_CD <- "X"

  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expected <- c(2, 2, 2, 2, 0, 0)

  expect_equal(fn012_out$SIZSAM, expected)
})


test_that("sizsam updated to 1 if just fn125", {
  fn124$PRJ_CD <- "X"
  fn125$GRP[c(5, 6)] <- "10"

  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expected <- c(1, 1, 1, 1, 0, 0)

  expect_equal(fn012_out$SIZSAM, expected)
})


test_that("sizsam updated if mix of fn124 and fn125", {
  fn124$GRP <- c("10", "10", "00", "10", "00", "00")
  fn125$GRP <- c("10", "00", "10", "00", "10", "00")

  fn012_out <- assign_fn012_sizesam(fn012_in, fn124, fn125)

  expected <- c(0, 1, 2, 1, 2, 3)

  expect_equal(fn012_out$SIZSAM, expected)
})
