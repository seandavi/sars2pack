context("Utility functions")

test_that('integer_to_fips works with integers', {
    expect_equal(integer_to_fips(1),
                 '00001')
    expect_equal(integer_to_fips(1:10)[10],
                 "00010")
})

test_that('integer_to_fips errors with character input', {
    expect_error(integer_to_fips("1"))
})

test_that('county_to_state_fips converts as expected', {
    expect_equal(county_to_state_fips('05050'), "00005")
    
})

test_that('county_to_state_fips errors if not character input of length 5', {
    expect_error(county_to_state_fips(50))
    expect_error(county_to_state_fips('50'))
})


