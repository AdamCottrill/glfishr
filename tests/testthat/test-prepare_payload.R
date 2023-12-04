payload <- data.frame(
  prj_cd = "LHA_IA22_123", sam = 1,
  slug = "lha_ia22_123-1",
  id = 1
)


test_that("prepare payload removes slug and returns uppercase by default", {
  observed <- prepare_payload(payload)
  expected <- payload[, c(1, 2)]
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


test_that("prepare payload return column names unchanged if to_upper=False", {
  observed <- prepare_payload(payload, to_upper = F)
  expected <- payload[, c(1, 2)]
  expect_equal(observed, expected)
})


test_that("prepare payload return includes id and slug if show_id=True", {
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


# return dataframe as is

# return data frame without an ID field as is
test_that("prepare payload works if id is missing in payload", {
  payload$id <- NULL
  observed <- prepare_payload(payload)
  expected <- payload[, c(1, 2)]
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


test_that("prepare payload works if id is missing in payload and show_ids=T", {
  payload$id <- NULL
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


# return data frame without an SLUG field as is
test_that("prepare payload works if slug is missing in payload", {
  payload$slug <- NULL
  observed <- prepare_payload(payload)
    expected <- payload[, c(1, 2)]
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


test_that("prepare payload works if slug is missing in payload and show_ids=T", {
  payload$slug <- NULL
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})





test_that("prepare payload return includes ID and SLUG if show_id=True",
{
  #works if field names are upper case too:
  names(payload) <- toupper(names(payload))
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


# return dataframe as is

# return data frame without an ID field as is
test_that("prepare payload works if ID is missing in payload", {

  payload$id <- NULL
  #works if field names are upper case too:
  names(payload) <- toupper(names(payload))
  observed <- prepare_payload(payload)
  expected <- payload[, c(1, 2)]
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


test_that("prepare payload works if ID is missing in payload and show_ids=T", {
  payload$id <- NULL
  #works if field names are upper case too:
  names(payload) <- toupper(names(payload))
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


# return data frame without an SLUG field as is
test_that("prepare payload works if SLUG is missing in payload", {
  payload$slug <- NULL
  #works if field names are upper case too:
  names(payload) <- toupper(names(payload))
  observed <- prepare_payload(payload)
    expected <- payload[, c(1, 2)]
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})


test_that("prepare payload works if SLUG is missing in payload and show_ids=T", {
  payload$slug <- NULL
  #works if field names are upper case too:
  names(payload) <- toupper(names(payload))
  observed <- prepare_payload(payload, show_id = T)
  expected <- payload
  names(expected) <- toupper(names(expected))
  expect_equal(observed, expected)
})





# return data frame without a slug field as is

# return data frame without either a slug or id as is

# convert names of returned data frame to uppercase
