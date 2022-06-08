#' COG functional categories
#'
#' Letter code mappings of COG functional categories.
#'
#' @export
#' @note Updated 2022-06-08.
#'
#' @return `DataFrame`.
#' Contains columns `"letter"`, `"description"`, and `"class"`.
#'
#' @seealso
#' - http://eggnog5.embl.de/download/eggnog_4.5/COG_functional_categories.txt
#'
#' @examples
#' object <- cogFunctionalCategories()
#' print(object)
cogFunctionalCategories <- function() {
    readRDS(system.file(
        "extdata", "cog-functional-categories.rds",
        package = packageName(),
        mustWork = TRUE
    ))
}
