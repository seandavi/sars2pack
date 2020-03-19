
> # LOADING PACKAGES BY C. MOREFIELD
> if (!requireNamespace("BiocManager", quietly = TRUE))
+        install.packages("BiocManager")
Installing package into ‘/Users/jcma/Library/R/3.6/library’
(as ‘lib’ is unspecified)
--- Please select a CRAN mirror for use in this session ---
trying URL 'https://cran.mtu.edu/bin/macosx/el-capitan/contrib/3.6/BiocManager_1.30.10.tgz'
Content type 'application/x-gzip' length 94951 bytes (92 KB)
==================================================
downloaded 92 KB


The downloaded binary packages are in
	/var/folders/hw/9_s9ccyj1vgc6cj45649jt7w0000gq/T//RtmpbIiv9T/downloaded_packages
> BiocManager::install()
Bioconductor version 3.10 (BiocManager 1.30.10), R 3.6.2 (2019-12-12)
Installing package(s) 'BiocVersion'
trying URL 'https://bioconductor.org/packages/3.10/bioc/bin/macosx/el-capitan/contrib/3.6/BiocVersion_3.10.1.tgz'
Content type 'application/x-gzip' length 5574 bytes
==================================================
downloaded 5574 bytes


The downloaded binary packages are in
	/var/folders/hw/9_s9ccyj1vgc6cj45649jt7w0000gq/T//RtmpbIiv9T/downloaded_packages
Installation path not writeable, unable to update packages: boot, foreign, lattice, MASS, nlme, nnet, survival
> BiocManager::install("MASS")
Bioconductor version 3.10 (BiocManager 1.30.10), R 3.6.2 (2019-12-12)
Installing package(s) 'MASS'
trying URL 'https://cran.mtu.edu/bin/macosx/el-capitan/contrib/3.6/MASS_7.3-51.5.tgz'
Content type 'application/x-gzip' length 1160968 bytes (1.1 MB)
==================================================
downloaded 1.1 MB


The downloaded binary packages are in
	/var/folders/hw/9_s9ccyj1vgc6cj45649jt7w0000gq/T//RtmpbIiv9T/downloaded_packages
Installation path not writeable, unable to update packages: boot, foreign, lattice, MASS, nlme, nnet, survival
> install.packages("R0")
Installing package into ‘/Users/jcma/Library/R/3.6/library’
(as ‘lib’ is unspecified)
trying URL 'https://cran.mtu.edu/bin/macosx/el-capitan/contrib/3.6/R0_1.2-6.tgz'
Content type 'application/x-gzip' length 219977 bytes (214 KB)
==================================================
downloaded 214 KB


The downloaded binary packages are in
	/var/folders/hw/9_s9ccyj1vgc6cj45649jt7w0000gq/T//RtmpbIiv9T/downloaded_packages
> ## Demo file
> library(R0)
Loading required package: MASS
> 
> # Generating an epidemic with given parameters
> mGT <- generation.time("gamma", c(3,1.5))
> mEpid <- sim.epid(epid.nb=1, GT=mGT, epid.length=30, family="poisson", R0=1.67, peak.value=500)
> mEpid <- mEpid[,1]
> # Running estimations
> est <- estimate.R(epid=mEpid, GT=mGT, methods=c("EG","ML","TD"))
Waiting for profiling to be done...
Warning messages:
1: In est.R0.TD(epid = c(1, 1, 1, 1, 1, 3, 1, 2, 1, 6, 2, 6, 4, 12,  :
  Simulations may take several minutes.
2: In est.R0.TD(epid = c(1, 1, 1, 1, 1, 3, 1, 2, 1, 6, 2, 6, 4, 12,  :
  Using initial incidence as initial number of cases.
> 
> # Model estimates and goodness of fit can be plotted
> plot(est)
> plotfit(est)
# Sensitivity analysis for the EG estimation; influence of begin/end dates
s.a <- sensitivity.analysis(res=est$estimates$EG, begin=1:15, end=16:30, sa.type="time")
# This sensitivity analysis can be plotted
plot(s.a)

# RUN PATTERN DEVELOPED BY C. MOREFIELD and ABSTRACTED by J. Mallery

fetch_JHU_Data <- function() {
	csv <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
	data <- read.csv(text = csv, check.names = F)
	names(data)[1] <- "ProvinceState"
	names(data)[2] <- "CountryRegion"
	numberColumns <- length(names(data))
	data.table(data) }
	
trimLeading <- function(x, value=0) {
	w <- which.max(cummax(x != value))
	x[seq.int(w, length(x))] }

extract_country_data <- function (name, data) {
	cdata <- data[CountryRegion == name] 
	cdata}

extract_ProvinceState_data <- function (name, data) {data[ProvinceState == name] }

prepare_data <- function (cdata) {
	cdata <- cdata[,5:numberColumns] 
	names(cdata) <- NULL
	cdata <- unlist(c(cdata))
	cdata <- append(cdata[1], diff(cdata))
	cdata <- trimLeading(cdata, value = 0) 
	cdata}

# SERIAL TIME INTERVAL
GT.cov2 <- generation.time("gamma", c(3.96, 0.41))
# EUROPE	
epid.count <- prepare_data(extract_ProvinceState_data("France", my_data))
R.France <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.France 

epid.count <- prepare_data(extract_country_data("Germany", my_data))
R.Germany <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Germany

epid.count <- prepare_data(extract_country_data("Italy", my_data))
R.Italy <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Italy

epid.count <- prepare_data(extract_country_data("Spain", my_data))
R.Spain <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Spain 

epid.count <- prepare_data(extract_ProvinceState_data("United Kingdom", my_data))
R.UK <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.UK

# MIDDLE EAST
epid.count <- prepare_data(extract_country_data("Iran", my_data))
R.Iran<- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Iran 

# ASIA
epid.count <- prepare_data(extract_country_data("Korea, South", my_data))
R.SouthKorea <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.SouthKorea

epid.count <- prepare_data(extract_country_data("Singapore", my_data))
R.Singapore <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Singapore

# US States and Regions
epid.count <- prepare_data(extract_ProvinceState_data("New York", my_data))
R.NewYork <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.NewYork

epid.count <- prepare_data(extract_ProvinceState_data("New Hampshire", my_data))
R.NewHampshire <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.NewHampshire

epid.count <- prepare_data(extract_ProvinceState_data("Illinois", my_data))
R.Illinois <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Illinois


