## Updated 2021-02-21.
.cacheIt <- function(file) {
    assert(isString(file))
    if (isAUrl(file)) {
        x <- cacheUrl(url = file, pkg = .pkgName)
    } else {
        x <- file
    }
    assert(isAFile(x))
    x
}
