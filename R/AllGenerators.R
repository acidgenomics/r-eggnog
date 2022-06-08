#' @name EggNOG
#' @inherit EggNOG-class title description return
#' @note Updated 2022-06-07.
#'
#' @param release `character(1)`.
#'   EggNOG release version.
#'
#' @examples
#' object <- EggNOG()
#' print(object)
NULL



#' EggNOG 5.0 annotations
#'
#' @note Updated 2022-06-07.
#' @noRd
#'
#' @details
#' May want to convert "28H50" identifier to "ENOG5028H51", for example.
.annotations50 <- function(baseUrl) {
    df <- import(
        file = .cacheIt(pasteURL(
            baseUrl,
            "per_tax_level",
            "1",
            "1_annotations.tsv.gz",
            protocol = "none"
        )),
        colnames = c(
            "taxonomicLevel",
            "eggnogId", # groupName
            "cogFunctionalCategory",
            "consensusFunctionalDescription"
        ),
        engine = "data.table"
    )
    df
}



#' EggNOG 4.5 annotations
#'
#' @note Updated 2022-06-08.
#' @noRd
.annotations45 <-  ## nolint
    function(baseUrl) {
        colnames <- c(
            "taxonomicLevel",
            "eggnogId", # groupName
            "proteinCount",
            "speciesCount",
            "cogFunctionalCategory",
            "consensusFunctionalDescription"
        )
        ## euNOG: Eukaryota.
        eunog <- import(
            file = .cacheIt(pasteURL(
                baseUrl, "data", "euNOG", "euNOG.annotations.tsv.gz",
                protocol = "none"
            )),
            colnames = FALSE
        )
        colnames(eunog) <- colnames
        ## NOG: LUCA.
        nog <- import(
            file = .cacheIt(pasteURL(
                baseUrl, "data", "NOG", "NOG.annotations.tsv.gz",
                protocol = "none"
            )),
            colnames = FALSE
        )
        ## Bind annotations.
        colnames(nog) <- colnames
        df <- rbind(eunog, nog)
        df
    }



## Updated 2022-06-07.
.annotations41 <- .annotations45



#' COG functional categories
#'
#' Letter code mappings of COG functional categories.
#'
#' @noRd
#' @note Updated 2022-06-08.
#'
#' @return `DataFrame`.
#' Contains columns `"letter"`, `"description"`, and `"class"`.
#'
#' @seealso
#' - http://eggnog5.embl.de/download/eggnog_4.5/COG_functional_categories.txt
#'
#' @examples
#' object <- .cogFunctionalCategories()
#' print(object)
.cogFunctionalCategories <- function() {
    readRDS(system.file(
        "extdata", "cog-functional-categories.rds",
        package = .pkgName,
        mustWork = TRUE
    ))
}



#' @rdname EggNOG
#' @export
EggNOG <-  # nolint
    function(release = c("5.0", "4.5", "4.1")) {
        release <- match.arg(release)
        ## EggNOG database doesn't support HTTPS currently.
        baseUrl <- pasteURL(
            "eggnog5.embl.de",
            "download",
            paste("eggnog", release, sep = "_"),
            protocol = "http"
        )
        what <- get(
            x = paste0(
                ".annotations",
                gsub(
                    pattern = ".",
                    replacement = "",
                    x = release,
                    fixed = TRUE
                )
            ),
            envir = asNamespace(.pkgName),
            inherits = FALSE,
        )
        assert(is.function(what))
        args <- list("baseUrl" = baseUrl)
        df <- do.call(what = what, args = args)
        df <- as(df, "DataFrame")
        df <- df[
            ,
            c(
                "eggnogId",
                "consensusFunctionalDescription",
                "cogFunctionalCategory"
            )
        ]
        df <- df[order(df[["eggnogId"]]), , drop = FALSE]
        annotations <- df
        categories <- .cogFunctionalCategories()
        object <- SimpleList(
            "cogFunctionalCategories" = categories,
            "annotations" = annotations
        )
        metadata(object) <- list(
            "date" = Sys.Date(),
            "release" = release,
            "packageVersion" = .pkgVersion
        )
        new(Class = "EggNOG", object)
    }
