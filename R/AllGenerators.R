## FIXME Need to add support for version 5.
## The 5.0 release has a different file hierarchy
## FIXME Need to prefix these with "ENOG50".
## FIXME Yep this is it! Good to go.
## root annotations
## http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/1/1_annotations.tsv.gz
## Eukaryota
## http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2759/
## FIXME I think this is the new main annotation mapping file...
## - http://eggnog5.embl.de/download/eggnog_5.0/e5.og_annotations.tsv
## - http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/28890/
## - http://eggnog5.embl.de/download/eggnog_5.0/e5.taxid_info.tsv
## - http://eggnog5.embl.de/download/eggnog_5.0/e5.level_info.tar.gz
## > xxx <- import(
## >     file = "http://eggnog5.embl.de/download/eggnog_5.0/e5.level_info.tar.gz",
## >     format = "tsv",
## >     skip = 1L,
## >     engine = "readr",
## >     colnames = FALSE
## > )

## http://eggnog5.embl.de/download/eggnog_5.0/e5.taxid_info.tsv

## xxx = import("http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2759/2759_annotations.tsv.gz", colnames = FALSE)

## Homo sapiens = 9606
##
## FIXME Just save the cogFunctionalCategories in the package...simpler.
## FIXME Rename this



#' @name EggNOG
#' @inherit EggNOG-class title description return
#' @note Updated 2022-06-07.
#'
#' @param release `character(1)`.
#'   EggNOG release version (e.g. "4.5").
#'   Currently supported: "4.5", "4.1".
#'   Support for EggNOG 5 will be added in next release.
#'
#' @examples
#' x <- EggNOG()
#' print(x)
NULL



## FIXME This approach doesn't work. Need to rethink.

## Updated 2022-06-07.
.eggnog50 <- function() {
    stop("FIXME")
}



## Updated 2021-02-21.
.eggnog45 <-  ## nolint
    function(baseUrl) {
        eunogFile <- pasteURL(
            baseUrl, "data", "euNOG", "euNOG.annotations.tsv.gz",
            protocol = "none"
        )
        nogFile <- pasteURL(
            baseUrl, "data", "NOG", "NOG.annotations.tsv.gz",
            protocol = "none"
        )
        colnames <- c(
            "taxonomicLevel",
            "groupName",
            "proteinCount",
            "speciesCount",
            "cogFunctionalCategory",
            "consensusFunctionalDescription"
        )
        ## euNOG: Eukaryota.
        eunog <- import(file = .cacheIt(eunogFile), colnames = FALSE)
        eunog <- as(eunog, "DataFrame")
        colnames(eunog) <- colnames
        ## NOG: LUCA.
        nog <- import(file = .cacheIt(nogFile), colnames = FALSE)
        nog <- as(nog, "DataFrame")
        ## Bind annotations.
        colnames(nog) <- colnames
        df <- rbind(eunog, nog)
        df <- df[
            ,
            c(
                "groupName",
                "consensusFunctionalDescription",
                "cogFunctionalCategory"
            )
        ]
        colnames(df)[colnames(df) == "groupName"] <- "eggnogId"
        df <- df[order(df[["eggnogId"]]), , drop = FALSE]
        annotations <- df
        categories <- cogFunctionalCategories()
        SimpleList(
            "cogFunctionalCategories" = categories,
            "annotations" = annotations
        )
    }



## Updated 2021-02-21.
.eggnog41 <- .eggnog45



#' @rdname EggNOG
#' @export
EggNOG <-  # nolint
    function(release = c("5.0", "4.5", "4.1", "4.0")) {
        release <- match.arg(release)
        ## EggNOG database doesn't support HTTPS currently.
        baseUrl <- pasteURL(
            "eggnog5.embl.de",
            "download",
            paste("eggnog", release, sep = "_"),
            protocol = "http"
        )
        ## e.g. ".eggnog50".
        funName <- paste0(
            ".eggnog",
            gsub(
                pattern = ".",
                replacement = "",
                x = release,
                fixed = TRUE
            )
        )
        what <- get(funName, inherits = TRUE)
        assert(is.function(what))
        args <- list("baseUrl" = baseUrl)
        data <- do.call(what = what, args = args)
        metadata(data) <- list(
            "date" = Sys.Date(),
            "release" = release,
            "packageVersion" = packageVersion(packageName())
        )
        new(Class = "EggNOG", data)
    }
