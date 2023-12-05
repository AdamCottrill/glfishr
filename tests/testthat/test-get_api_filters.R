


test_that("get_api_filters() throws an error if the url is bad", {
    mockery::stub(
    get_api_filters,
    "get_swagger_url",
    "http://127.0.0.1:8888/",
    )

  expect_error(get_api_filters("fn_portal"),
    "unable to fetch filters from the server. Is your VPN active?")


})
