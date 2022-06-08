# EggNOG

[EggNOG][] database annotations.

## Installation

### [R][] method

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
install.packages(
    pkgs = "EggNOG",
    repos = c(
        "https://r.acidgenomics.com",
        BiocManager::repositories()
    )
)
```

FIXME Make it clear that this package is simple. For identifier mapping,
refer to eggnog-mapper Python package.

[eggnog]: http://eggnog.embl.de/
[r]: https://www.r-project.org/
