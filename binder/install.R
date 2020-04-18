install.packages(c("BiocManager", "remotes"))
# this is to shortcut the errors during docker
# testing. sf will be installed as a dependency
# without the next line.
install.packages('sf')
BiocManager::install(c("seandavi/sars2pack","plumber","EpiEstim", "urltools","jsonlite"))
