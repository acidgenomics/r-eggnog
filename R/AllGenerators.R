#' @inherit EggNOG-class title description return
#' @note Updated 2020-07-23.
#' @export
#' @examples
#' options(acid.test = TRUE)
#' x <- EggNOG()
#' print(x)
EggNOG <-  # nolint
    function() {
        assert(hasInternet())
        ## EggNOG database doesn't support HTTPS currently.
        baseURL <- pasteURL(
            "eggnog5.embl.de", "download", "latest",
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
        ## FIXME USE IMPORT INSTEAD...
        x <- readLines(categoriesFile)
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
        ## euNOG: Eukaryota
        eunog <- as(import(eunogFile, colnames = FALSE), "DataFrame")
        colnames(eunog) <- colnames
        ## NOG: LUCA
        nog <- as(import(nogFile, colnames = FALSE), "DataFrame")
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
            cogFunctionalCategories = categories,
            annotations = annotations
        )
        metadata(data) <- list(
            version = packageVersion(packageName()),
            date = Sys.Date()
        )
        new(Class = "EggNOG", data)
    }
