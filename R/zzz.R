.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "This is version ", utils::packageVersion(pkgname),
    " of ", pkgname
  )
}
