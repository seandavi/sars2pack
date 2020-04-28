FROM rocker/geospatial

RUN Rscript -e 'install.packages("BiocManager")'
RUN Rscript -e 'BiocManager::install(c("seandavi/sars2pack","plumber"))'
RUN Rscript -e 'BiocManager::install("EpiEstim")'
RUN Rscript -e 'BiocManager::install("urltools")'
RUN Rscript -e 'BiocManager::install("jsonlite")'

COPY api.R api.R

ENV PORT=8080
EXPOSE $PORT
ARG GIT_COMMIT=unspecified

LABEL git_commit=$GIT_COMMIT

CMD exec Rscript -e 'plumber::plumb("api.R")$run(host="0.0.0.0", swagger=TRUE, port=as.integer(Sys.getenv("PORT")))'
