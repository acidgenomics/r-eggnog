## nolint start
suppressPackageStartupMessages({
    library(pipette)
})
## nolint end
object <- import("cog-functional-categories.csv")
saveRDS(object, "cog-functional-categories.rds")
