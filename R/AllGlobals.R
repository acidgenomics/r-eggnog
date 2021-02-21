#' Package version
#'
#' @note Updated 2021-02-21.
#' @noRd
.version <- packageVersion(packageName())



#' EggNOG test data URL
#'
#' @export
#' @keywords internal
#' @note Updated 2021-02-21.
#'
#' @examples
#' EggNOGTestsURL
EggNOGTestsURL <-  # nolint
    paste0(
        "https://r.acidgenomics.com/testdata/eggnog/",
        "v", .version$major, ".", .version$minor  # nolint
    )
