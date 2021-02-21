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



## Updated 2021-02-21.
.eggnog4 <- function(baseURL) {
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
    SimpleList(
        "cogFunctionalCategories" = categories,
        "annotations" = annotations
    )
}



#' @rdname EggNOG
#' @export
EggNOG <-  # nolint
    function(release = "4.5") {
        assert(
            hasInternet(),
            isString(release, nullOK = TRUE)
        )
        ## EggNOG database doesn't support HTTPS currently.
        baseURL <- pasteURL(
            "eggnog5.embl.de",
            "download",
            ifelse(
                test = is.null(release),
                yes = "latest",
                no = paste("eggnog", release, sep = "_")
            ),
            protocol = "http"
        )
        ## FIXME NEED TO WRITE METHOD TO SWITCH TO EGGNOG 4 here.
        data <- .eggnog4(baseURL = baseURL)
        metadata(data) <- list(
            "date" = Sys.Date(),
            "release" = release,
            "packageVersion" = packageVersion(packageName())
        )
        new(Class = "EggNOG", data)
    }
