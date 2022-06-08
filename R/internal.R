## Updated 2021-02-21.
.cacheIt <- function(file) {
    assert(isString(file))
    if (isAURL(file)) {
        x <- cacheURL(url = file, pkg = .pkgName)
    } else {
        x <- file
    }
    assert(isAFile(x))
    x
}
