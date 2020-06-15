context("Plotting functions")

jhu = jhu_data() %>% 
    filter(CountryRegion=='China' & subset=='confirmed') %>% 
    group_by(CountryRegion,date) %>% summarize(count=sum(count))

test_that('plot_epicurve returns ggplot object', {
    grob = plot_epicurve(jhu)
    expect_is(grob, 'gg')
    expect_is(grob, 'ggplot')
})

test_that('plot_epicurve filtering works', {
    grob = plot_epicurve(jhu, filter_expression = CountryRegion=="China")
    expect_is(grob, 'gg')
    expect_is(grob, 'ggplot')
})
