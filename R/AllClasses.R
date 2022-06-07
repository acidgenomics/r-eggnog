#' EggNOG database annotations
#'
#' [EggNOG](http://eggnogdb.embl.de) is a database of biological information
#' hosted by the EMBL. It is based on the original idea of COGs (**c**lusters of
#' **o**rthologous **g**roups) and expands that idea to non-supervised
#' orthologous groups constructed from numerous organisms. eggNOG stands for
#' **e**volutionary **g**enealogy of **g**enes: **N**on-supervised
#' **O**rthologous **G**roups.
#'
#' This class extends `list` and contains:
#'
#' 1. `"cogFunctionalCategories"`: **C**luster of **O**rthologous **G**roups
#'    (COG) functional category information.
#' 2. `"annotations"`: up-to-date functional descriptions and categories
#'    for **Eu**karyotes **N**on-supervised **O**rthologous **G**roups (euNOG)
#'    and **N**on-supervised **O**rthologous **G**roups (NOG) protein
#'    identifiers.
#'
#' The [EggNOG README](http://eggnogdb.embl.de/download/latest/README.txt)
#' contains additional useful reference information.
#'
#' @note Updated 2019-08-13.
#' @export
#'
#' @return `EggNOG`.
setClass(
    Class = "EggNOG",
    contains = "SimpleDFrameList"
)
setValidity(
    Class = "EggNOG",
    method = function(object) {
        validate(
            identical(
                x = names(object),
                y = c("cogFunctionalCategories", "annotations")
            ),
            identical(
                x = colnames(object[["cogFunctionalCategories"]]),
                y = c("letter", "description")
            ),
            identical(
                x = colnames(object[["annotations"]]),
                y = c(
                    "eggnogId",
                    "consensusFunctionalDescription",
                    "cogFunctionalCategory"
                )
            )
        )
    }
)
