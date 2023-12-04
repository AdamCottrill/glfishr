## THe populate_gept() function compiles the gear-effort-process type
## for each gear and process type used in the selected proejcts.


gr_eff_proc_type <- structure(
  list(
    GR = c(
      "GL21", "GL21", "GL21", "GL21", "GL21",
      "GL21", "GL21", "GL21", "GL21", "GL21", "GL21", "GL21", "NA1",
      "NA1", "NA1", "NA1", "NA1", "NA1", "NA1", "NA1", "NA1", "ON2",
      "ON2", "ON2", "ON2", "ON2", "ON2"
    ),
    PROCESS_TYPE = c(
      "1", "2",
      "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "1", "2", "2",
      "2", "2", "2", "2", "2", "2", "1", "2", "2", "2", "2", "2"
    ),
    EFF = c(
      "001", "032", "038", "051", "064", "076", "089",
      "102", "114", "127", "140", "153", "001", "038", "051", "064",
      "076", "089", "102", "114", "127", "001", "013", "019", "025",
      "032", "038"
    ),
    EFFDST = c(
      490, 15, 25, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 24.8, 3.1, 3.1, 3.1, 3.1, 3.1, 3.1, 3.1,
      3.1, 12.5, 2.5, 2.5, 2.5, 2.5, 2.5
    )
  ),
  class = "data.frame", row.names = c(NA, 27L)
)


fn028 <- structure(
  list(
    PRJ_CD = c("LHA_IA19_005", "LHA_IA22_810", "LHA_IA22_810"),
    MODE = c("01", "01", "02"),
    GR = c("GL21", "NA1", "ON2")
  ),
  row.names = c(NA, 3L), class = "data.frame"
)




fn121 <- structure(
  list(
    PRJ_CD = c("LHA_IA19_005", "LHA_IA22_810", "LHA_IA22_810"),
    MODE = c("01", "01", "02"),
    PROCESS_TYPE = c("2", "2", "2")
  ),
  row.names = c(1L, 31L, 37L), class = "data.frame"
)





test_that("populate_gept works with known quantities", {
  mockery::stub(
    populate_gept,
    "get_gear_process_types",
    gr_eff_proc_type
  )
  observed <- populate_gept(fn028, fn121)

  # each combination of gears and process types should be in return
  # data frame:
  obs_keys <- apply(unique(observed[c("GR", "PROCESS_TYPE")]), 1, paste, collapse = "-")

  expected <- c("GL21-2", "NA1-2", "ON2-2")
  expect_equal(obs_keys, expected, ignore_attr = TRUE)
})




test_that("unused process types will be ignored", {
  mockery::stub(
    populate_gept,
    "get_gear_process_types",
    gr_eff_proc_type
  )
  observed <- populate_gept(fn028, fn121)

  obs_keys <- apply(unique(observed[c("GR", "PROCESS_TYPE")]), 1, paste, collapse = "-")

  # the gear-process type values are in  gear-process-type fixture.
  # not used used and should be returned
  unused_process_types <- c("GL21-1", "NA1-1", "ON2-1")
  for (proc_type in unused_process_types) {
    expect_false(proc_type %in% obs_keys)
  }
})


test_that("unknown process types in fn121 also be ignored", {

  new_fn121 <- fn121[1,]
  new_fn121$PROCESS_TYPE <- 7
  fn121 <- rbind(fn121, new_fn121)

  mockery::stub(
    populate_gept,
    "get_gear_process_types",
    gr_eff_proc_type
  )
  observed <- populate_gept(fn028, fn121)

  obs_keys <- apply(unique(observed[c("GR", "PROCESS_TYPE")]), 1, paste, collapse = "-")
  # these are unchanged:
  expected <- c("GL21-2", "NA1-2", "ON2-2")
  expect_equal(obs_keys, expected, ignore_attr = TRUE)

  expect_false(new_fn121$PROCESS_TYPE %in% observed$PROCESS_TYPE)
})


test_that("unknown gear codes in the fn028 table are ignored.", {

  new_fn028 <- fn028[1,]
  new_fn028$GR <- "GL99"
  fn028 <- rbind(fn028, new_fn028)

  mockery::stub(
    populate_gept,
    "get_gear_process_types",
    gr_eff_proc_type
  )
  observed <- populate_gept(fn028, fn121)

  obs_keys <- apply(unique(observed[c("GR", "PROCESS_TYPE")]), 1, paste, collapse = "-")
  # these are unchanged:
  expected <- c("GL21-2", "NA1-2", "ON2-2")
  expect_equal(obs_keys, expected, ignore_attr = TRUE)

  expect_false(new_fn028$GR %in% observed$GR)
})
