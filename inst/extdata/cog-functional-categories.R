## nolint start
suppressPackageStartupMessages({
    library(pipette)
})
## nolint end
object <- import("cog-functional-categories.csv")
object <- as(object, "DataFrame")
object[["class"]] <- as.factor(object[["class"]])
saveRDS(object, "cog-functional-categories.rds")
