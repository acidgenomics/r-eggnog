## Updated 2021-02-21.
.cacheIt <- function(file) {
    assert(isString(file))
    if (isAURL(file)) {
        x <- cacheURL(url = file, pkg = packageName())
    } else {
        x <- file
    }
    assert(isAFile(x))
    x
}
