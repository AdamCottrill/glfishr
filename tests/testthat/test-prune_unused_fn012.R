
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

fn012_in <- data.frame(PRJ_CD=prj_cds, GRP=grps, SPC=spcs)
fn123 <- data.frame(PRJ_CD=prj_cds, GRP=grps, SPC=spcs)


test_that("no change when fn012 and fn123 are equal", {
  fn012_out <- prune_unused_fn012(fn012_in, fn123)

  expect_equal(fn012_out, fn012_in)
})


test_that("no change when fn123 is empty", {
  fn012_out <- prune_unused_fn012(fn012_in, list())
  expect_equal(fn012_out, fn012_in)
})


test_that("extra rows removed from fn012", {
  #randomly drop two rows from out fn123:
  fn123 <- fn123[-c(1,3),]
  fn012_out <- prune_unused_fn012(fn012_in, fn123)
  expect_equal(fn012_out, fn123)
})



test_that("extra columns in fn123 ignored", {
  fn123$EXTRA <- "FOO"
  fn012_out <- prune_unused_fn012(fn012_in, fn123)

  expect_equal(fn012_out, fn012_in)
})


test_that("extra columns in fn012 perserved", {
  fn012_in$EXTRA <- "FOO"
  fn012_out <- prune_unused_fn012(fn012_in, fn123)
  expect_equal(fn012_out, fn012_in)
})
