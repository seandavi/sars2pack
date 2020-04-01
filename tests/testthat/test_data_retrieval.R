context("Data retrieval from web")

test_that("NY times state data is correct", {

    dat = nytimes_state_data()
    expect_equal(ncol(dat), 5)
})

test_that("NY times county data is correct", {

    dat = nytimes_county_data()
    expect_equal(ncol(dat), 6)
})


test_that("USAfacts data is correct", {
    dat = usa_facts_data()

    expect_equal(ncol(dat), 7)
})
