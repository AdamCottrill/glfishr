test_that("get_swagger_payload() throws an error if the url is bad", {
  mockery::stub(
    get_swagger_payload,
    "get_swagger_url",
    "http://127.0.0.1:8888/",
  )

  expect_error(
    get_swagger_payload("fn_portal"),
    "unable to fetch filters from the server. Is your VPN active?"
  )
})
