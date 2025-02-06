structure(list(
  url = "http://127.0.0.1:8000/api-auth/token/",
  status_code = 400L, headers = structure(list(
    date = "Wed, 06 Dec 2023 20:13:39 GMT",
    server = "WSGIServer/0.2 CPython/3.9.13", `content-type` = "application/json",
    allow = "POST, OPTIONS", `djdt-store-id` = "791841bea52144f5902edbd8b2354a74",
    `server-timing` = "TimerPanel_utime;dur=0;desc=\"User CPU time\", TimerPanel_stime;dur=0;desc=\"System CPU time\", TimerPanel_total;dur=0;desc=\"Total CPU time\", TimerPanel_total_time;dur=167.15693473815918;desc=\"Elapsed time\", SQLPanel_sql_time;dur=0.0;desc=\"SQL 1 queries\", CachePanel_total_time;dur=0;desc=\"Cache 0 Calls\"",
    `x-frame-options` = "DENY", `content-length` = "68",
    vary = "Cookie, Origin", `x-content-type-options` = "nosniff",
    `referrer-policy` = "same-origin"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 400L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Wed, 06 Dec 2023 20:13:39 GMT",
      server = "WSGIServer/0.2 CPython/3.9.13", `content-type` = "application/json",
      allow = "POST, OPTIONS", `djdt-store-id` = "791841bea52144f5902edbd8b2354a74",
      `server-timing` = "TimerPanel_utime;dur=0;desc=\"User CPU time\", TimerPanel_stime;dur=0;desc=\"System CPU time\", TimerPanel_total;dur=0;desc=\"Total CPU time\", TimerPanel_total_time;dur=167.15693473815918;desc=\"Elapsed time\", SQLPanel_sql_time;dur=0.0;desc=\"SQL 1 queries\", CachePanel_total_time;dur=0;desc=\"Cache 0 Calls\"",
      `x-frame-options` = "DENY", `content-length` = "68",
      vary = "Cookie, Origin", `x-content-type-options` = "nosniff",
      `referrer-policy` = "same-origin"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = logical(0),
    flag = logical(0), path = logical(0), secure = logical(0),
    expiration = structure(numeric(0), class = c(
      "POSIXct",
      "POSIXt"
    )), name = logical(0), value = logical(0)
  ), row.names = integer(0), class = "data.frame"),
  content = charToRaw("{\"non_field_errors\":[\"Unable to log in with provided credentials.\"]}"),
  date = structure(1701893619, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 7.7e-05,
    connect = 0.022406, pretransfer = 0.022831, starttransfer = 0.022839,
    total = 0.200567
  )
), class = "response")
