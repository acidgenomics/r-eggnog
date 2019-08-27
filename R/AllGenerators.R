#' @inherit EggNOG-class title description return
#' @note Updated 2019-08-15.
#' @export
#' @inheritParams acidroxygen::params
#' @examples
#' options(acid.test = TRUE)
#' x <- EggNOG()
#' print(x)
EggNOG <-  # nolint
    function() {
        assert(hasInternet())
        if (isTRUE(getOption("acid.test"))) {
            categoriesFile <- pasteURL(
                basejumpTestsURL, "cog.txt",
                protocol = "none"
            )
            eunogFile <- pasteURL(
                basejumpTestsURL, "eunog.tsv.gz",
                protocol = "none"
            )
            nogFile <- pasteURL(
                basejumpTestsURL, "nog.tsv.gz",
                protocol = "none"
            )
        } else {
            ## This is slow and unreliable on Travis, so cover locally.
            ## EggNOG database doesn't support HTTPS currently.
            ## nocov start
            url <- pasteURL(
                "eggnog5.embl.de", "download", "latest",
                protocol = "http"
            )
            categoriesFile <- pasteURL(
                url, "COG_functional_categories.txt",
                protocol = "none"
            )
            eunogFile <- pasteURL(
                url, "data", "euNOG", "euNOG.annotations.tsv.gz",
                protocol = "none"
            )
            nogFile <- pasteURL(
                url, "data", "NOG", "NOG.annotations.tsv.gz",
                protocol = "none"
            )
            ## nocov end
        }
        assert(
            isString(categoriesFile),
            isString(eunogFile),
            isString(nogFile)
        )

        ## Categories ----------------------------------------------------------
        pattern <- "^\\s\\[([A-Z])\\]\\s([A-Za-z\\s]+)\\s$"
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
        colnames(x)[colnames(x) == "groupName"] <- "eggnogID"
        x <- x[order(x[["eggnogID"]]), , drop = FALSE]
        annotations <- x

        ## Return --------------------------------------------------------------
        data <- SimpleList(
            cogFunctionalCategories = categories,
            annotations = annotations
        )
        metadata(data) <- list(
            version = packageVersion("EggNOG"),
            date = Sys.Date()
        )
        new(Class = "EggNOG", data)
    }
