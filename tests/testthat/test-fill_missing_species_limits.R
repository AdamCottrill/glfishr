# a dataframe created by using dput(species) on a data frame returned
# from get_species(list(spc="091,081,331,334",detail=TRUE))
# it will be used in a mock - everytime we call get_species, the
# function will return this dataframe instead of hitting the api
species_data <- structure(
  list(
    SPC = c("081", "091", "331", "334"),
    ABBREV = c(NA, NA, NA, NA),
    SPC_NMCO = c("lake trout", "lake whitefish", "yellow perch", "walleye"),
    SPC_NMSC = c(
      "Salvelinus namaycush",
      "Coregonus clupeaformis",
      "Perca flavescens",
      "Sander vitreus"
    ),
    SPC_NMFAM = c("SALMONINAE", "COREGONINAE", "PERCIDAE", "PERCIDAE"),
    SPC_LAB = c("LaTro", "LaWhi", "YePer", "Walle"),
    SPECIES_AT_RISK = c(FALSE, FALSE, FALSE, FALSE),
    FLEN_MIN = c(105, 9, 5, 52),
    FLEN_MAX = c(954, 750, 377, 830),
    TLEN_MIN = c(115, 10, 5, 55),
    TLEN_MAX = c(1020, 830, 398, 883),
    RWT_MIN = c(12, 0.1, 0.2, 1),
    RWT_MAX = c(12939, 5422, 931, 8100),
    K_MIN_ERROR = c(0.38, 0.36, 0.49, 0.36),
    K_MIN_WARN = c(0.52, 0.48, 0.67, 0.51),
    K_MAX_ERROR = c(2, 1.86, 2.19, 1.85),
    K_MAX_WARN = c(1.82, 1.69, 1.99, 1.68),
    FLEN2TLEN_ALPHA = c(6.99357, 3.83189, 1.35885, 3.64915),
    FLEN2TLEN_BETA = c(1.07702, 1.10289, 1.04306, 1.05276)
  ),
  class = "data.frame",
  row.names = c(NA, 4L)
)

# a small fn1012 table we will use for our test:
fn012 <- structure(
  list(
    PRJ_CD = c("LEA_SC18_123", "LEA_SC18_123", "LEA_SC18_123", "LEA_SC18_123"),
    SPC = c("081", "078", "331", "334"),
    GRP = c("00", "00", "00", "00"),
    GRP_DES = c("default group", "default group", NA, NA),
    FLEN_MIN = c(200, 217, NA, NA),
    FLEN_MAX = c(725, 769, NA, NA),
    TLEN_MIN = c(210, 234, NA, NA),
    TLEN_MAX = c(757, 784, NA, NA),
    RWT_MIN = c(84, 122, NA, NA),
    RWT_MAX = c(5255, 8632, NA, NA),
    K_MIN_ERROR = c(0.32, 0.54, NA, NA),
    K_MIN_WARN = c(0.53, 0.77, NA, NA),
    K_MAX_ERROR = c(2.21, 2.57, NA, NA),
    K_MAX_WARN = c(1.98, 2.34, NA, NA)
  ),
  row.names = c(
    9L,
    11L,
    37L,
    38L
  ),
  class = "data.frame"
)


# nothing missing, fn012 returns unchanged.

test_that("no missing values, fn012 returned unchanged", {
  fn012_in <- fn012[c(1, 2), ]

  mockery::stub(fill_missing_fn012_limits, "get_species", species_data)
  fn012_out <- fill_missing_fn012_limits(fn012_in)

  expect_equal(fn012_in, fn012_out)
})


# known species are populated where null.
test_that("known species are populate if their values are null", {
  # yellow perch and walleye are null in the fn012 fixture, but are
  # available in the species list - verfiy that they are populated
  # with the correct values in the returned dataframe

  columns <- c(
    "SPC",
    "FLEN_MIN",
    "FLEN_MAX",
    "TLEN_MIN",
    "TLEN_MAX",
    "RWT_MIN",
    "RWT_MAX",
    "K_MIN_ERROR",
    "K_MIN_WARN",
    "K_MAX_ERROR",
    "K_MAX_WARN"
  )

  mockery::stub(fill_missing_fn012_limits, "get_species", species_data)
  fn012_out <- fill_missing_fn012_limits(fn012)

  for (spc in c("331", "334")) {
    observed <- fn012_out[
      fn012_out$SPC == spc,
      names(fn012_out) %in%
        columns
    ]
    expected <- species_data[
      species_data$SPC == spc,
      names(species_data) %in%
        columns
    ]
    expect_equal(observed, expected, ignore_attr = TRUE)
  }
})


test_that("known species with values remain unchanged", {
  # Lake trout are already specified in the fn012 table - those values
  # should be returned from the update function unchanged

  columns <- c(
    "SPC",
    "FLEN_MIN",
    "FLEN_MAX",
    "TLEN_MIN",
    "TLEN_MAX",
    "RWT_MIN",
    "RWT_MAX",
    "K_MIN_ERROR",
    "K_MIN_WARN",
    "K_MAX_ERROR",
    "K_MAX_WARN"
  )

  mockery::stub(fill_missing_fn012_limits, "get_species", species_data)
  fn012_out <- fill_missing_fn012_limits(fn012)

  observed <- fn012_out[
    fn012_out$SPC == "081",
    names(fn012_out) %in%
      columns
  ]

  spc_data_081 <- species_data[
    species_data$SPC == "081",
    names(species_data) %in%
      columns
  ]

  original <- fn012[fn012$SPC == "081", names(fn012) %in% columns]

  expect_equal(original, observed, ignore_attr = TRUE)
  expect_false(isTRUE(all.equal(observed, spc_data_081)))
})


# extra fields not added to fn012 (e.g. - species at risk)
test_that("extra fields in spc not added to fn012", {
  mockery::stub(fill_missing_fn012_limits, "get_species", species_data)
  fn012_out <- fill_missing_fn012_limits(fn012)

  expect_equal(names(fn012), names(fn012_out))

  extra_names <- names(species_data)[
    !names(species_data) %in%
      names(fn012)
  ]
  # the intersection of the names returned and the extra names should
  # be an emtpy character vector:
  expect_equal(intersect(extra_names, names(fn012_out)), character())
})
