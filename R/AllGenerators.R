## FIXME The server has been reorganized as of v5.0, need to rethink...
##
## FIXME 404 error:
## http://eggnog5.embl.de/download/latest/COG_functional_categories.txt
##
## Versioned URL:
## http://eggnog5.embl.de/download/eggnog_5.0/



#' @name EggNOG
#' @inherit EggNOG-class title description return
#' @note Updated 2021-02-21.
#'
#' @param release `character` or `NULL`.
#'   EggNOG release version (e.g. "5.0").
#'   If set `NULL`, will download the latest release.
#'
#' @examples
#' x <- EggNOG()
#' print(x)
NULL



#' @rdname EggNOG
#' @export
EggNOG <-  # nolint
    function(release = "4.5") {
        assert(
            hasInternet(),
            isString(release, nullOK = TRUE)
        )
        ## FIXME NEED TO GET THE ACTUAL RELEASE FROM THE SYMLINK???
        if (is.null(release)) {
            release <- "latest"
        }
        ## EggNOG database doesn't support HTTPS currently.
        baseURL <- pasteURL(
            "eggnog5.embl.de",
            "download",
            ifelse(
                test = identical(release, "latest"),
                yes = "latest",
                no = paste("eggnog", release, sep = "_")
            ),
            protocol = "http"
        )
        categoriesFile <- pasteURL(
            baseURL, "COG_functional_categories.txt",
            protocol = "none"
        )
        eunogFile <- pasteURL(
            baseURL, "data", "euNOG", "euNOG.annotations.tsv.gz",
            protocol = "none"
        )
        nogFile <- pasteURL(
            baseURL, "data", "NOG", "NOG.annotations.tsv.gz",
            protocol = "none"
        )
        assert(
            isString(categoriesFile),
            isString(eunogFile),
            isString(nogFile)
        )
        ## Categories ----------------------------------------------------------
        pattern <- "^\\s\\[([A-Z])\\]\\s([A-Za-z\\s]+)\\s$"
        x <- import(
            file = .cacheIt(categoriesFile),
            format = "lines"
        )
        x <- str_subset(x, pattern)
        x <- str_match(x, pattern)
        x <- as(x, "DataFrame")
        x <- x[, c(2L, 3L)]
        colnames(x) <- c("letter", "description")
        x <- x[order(x[["letter"]]), , drop = FALSE]
        categories <- x
        ## Annotations ---------------------------------------------------------
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
        x <- rbind(eunog, nog)
        x <- x[
            ,
            c(
                "groupName",
                "consensusFunctionalDescription",
                "cogFunctionalCategory"
            )
            ]
        colnames(x)[colnames(x) == "groupName"] <- "eggnogId"
        x <- x[order(x[["eggnogId"]]), , drop = FALSE]
        annotations <- x
        ## Return --------------------------------------------------------------
        data <- SimpleList(
            "cogFunctionalCategories" = categories,
            "annotations" = annotations
        )
        metadata(data) <- list(
            "date" = Sys.Date(),
            "release" = release,
            "packageVersion" = packageVersion(packageName())
        )
        new(Class = "EggNOG", data)
    }
