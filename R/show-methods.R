#' Show an object
#' @name show
#' @inherit methods::show params return title
#' @keywords internal
#' @note Updated 2020-07-23.
NULL



## Updated 2019-08-18.
`show,EggNOG` <- # nolint
    function(object) {
        ## FIXME This function doesn't work correctly with DataFrameList...
        ## need to fix this.
        showHeader(object)
        ids <- sort(object[["annotations"]][["eggnogId"]])
        categories <- sort(object[["cogFunctionalCategories"]][["description"]])
        showSlotInfo(list(
            ids = ids,
            categories = categories
        ))
    }



#' @rdname show
#' @export
setMethod(
    f = "show",
    signature = signature(object = "EggNOG"),
    definition = `show,EggNOG`
)
