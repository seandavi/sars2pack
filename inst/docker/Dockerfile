FROM rocker/geospatial

RUN Rscript -e 'install.packages("BiocManager")'
RUN Rscript -e 'BiocManager::install(c("seandavi/sars2pack","plumber"))'
RUN Rscript -e 'BiocManager::install("EpiEstim")'
RUN Rscript -e 'BiocManager::install("urltools")'
RUN Rscript -e 'BiocManager::install("jsonlite")'

ENV PORT=8080
EXPOSE $PORT
ARG GIT_COMMIT=unspecified

LABEL git_commit=$GIT_COMMIT


