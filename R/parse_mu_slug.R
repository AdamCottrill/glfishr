#' Parse Management Unit Slug
#'
#' Using the mu_type filter to add management units to the FN121 table results in the
#' field being populated with the management unit slug. Use `parse_mu_slug` to replace
#' the slug with the proper name of the management unit. The default for parsed slugs
#' is all upper case - use toupper=FALSE for title case (first letter of each word
#' capitalized).
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return string
#' @export
#'
#' @examples
#' huron_offshore_19 <- get_FN121(list(lake = "HU", protocol = "OSIA", year = 2019, mu_type = "basin"))
#' huron_offshore_19$MANAGEMENT_UNIT <- parse_mu_slug(huron_offshore_19$MANAGEMENT_UNIT)
#'
parse_mu_slug <- function(mu_slug, toupper = TRUE) {
  mu_name <- toupper(sapply(strsplit(mu_slug, "_"), function(x) x[3]))
  mu_name <- gsub("-", " ", mu_name)

  if (toupper == FALSE) {
    mu_name <- tolower(mu_name)
    mu_name <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", mu_name, perl = TRUE)
  }

  return(mu_name)
}
