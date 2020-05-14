gb0514 = function() 
  yaml::read_yaml(system.file("genbank/ncov-sequences-2020-05-14.yaml", package="sars2pack"))

getacc = function()
 sapply(gb0514()$`genbank-sequences`, "[[", "accession")
