for (release in eval(formals("EggNOG")[["release"]])) {
    test_that(paste("EggNOG", release), {
        object <- EggNOG(release = release)
        expect_s4_class(object, "EggNOG")
        expect_identical(length(object), 2L)
        expect_output(
            object = show(object),
            regexp = "EggNOG"
        )
    })
}
