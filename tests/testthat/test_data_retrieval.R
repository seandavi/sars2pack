context("Data retrieval from web")

##################
## NYTimes data ##
##################

test_that("NY times state data is correct", {

    dat = nytimes_state_data()
    expect_equal(ncol(dat), 5)
})

test_that("NY times county data is correct", {

    dat = nytimes_county_data()
    expect_equal(ncol(dat), 6)
})

###################
## USAFacts data ##
###################

test_that("USAfacts data is correct", {
    dat = usa_facts_data()

    expect_equal(ncol(dat), 7)
})


######################
## Country metadata ##
######################

test_that("USAfacts data is correct", {
    dat = country_metadata()

    expect_equal(ncol(dat), 24)
})


######################
## GLOBAL metadata ##
######################

test_that("jhu data is correct", {
    dat = jhu_data()

    expect_equal(ncol(dat), 7)
})

test_that("enriched jhu data is correct", {
    dat = enriched_jhu_data()

    expect_equal(ncol(dat), 20)
})

############################
## US Healthcare Capacity ##
############################

test_that("us healthcare data is correct", {
    dat = us_healthcare_capacity()

    expect_equal(ncol(dat), 23)
})

#####################
## County metadata ##
#####################

test_that("county metadata is correct", {
    dat = us_county_geo_details()

    expect_equal(ncol(dat), 9)
    expect_s3_class(dat$geometry,'sfc_POINT')
})




