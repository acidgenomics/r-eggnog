test_that("EggNOG", {
    object <- EggNOG()
    expect_s4_class(object, "EggNOG")
    expect_length(object, 2L)
    expect_output(
        object = show(object),
        regexp = "EggNOG"
    )
})
