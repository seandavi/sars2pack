library(deSolve) #Needed for solving DEs
library(tidyverse)
library(R0)
library(Epi)
library(Cairo)
library(scales)

#Data Needed
us.data<-read_csv("https://static.usafacts.org/public/data/covid-19/covid_confirmed_usafacts.csv?_ga=2.161264510.2114667733.1584890934-1059662301.1584890934")
#Current JHU Data
full.data<-read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")


#This code assumes a 4x ascertainment rate
#User Supplies County name, state, number of initial exposed, initial infected at pandemic start
date.of.pandemic.start<-"2020-3-21"
county<-"Westchester County" 
state<-"NY"
ascertainment.rate<-4
Population<-980244
exposed.rate<-2 #2 times infected population have been exposed
mGT <- generation.time("weibull", c(4.3,2.3)) #Generation distribution from https://www.ijidonline.com/article/S1201-9712(20)30119-3/pdf.

###############
Exposed.init <-5000

k<-as.numeric(lubridate::today()-as.Date(date.of.pandemic.start))

county.of.interest <- test.data<-us.data%>%filter(`County Name` == county & State == state)
Infected.init<-as.numeric(county.of.interest[ncol(county.of.interest)-k])
Exposed.init<-Infected.init*hidden

Exposed.init<-Exposed.init*ascertainment.rate
Infected.init <-Infected.init*ascertainment.rate


######################################################################
#### ITALY ANALYSIS START 

#Italy Data
Italy<-full.data%>%filter(`Country/Region`=="Italy")%>%
  dplyr::select(-`Province/State`,-`Country/Region`,-Lat,-Long)
vec<-as.numeric(Italy)
daily<-diff(vec)+1
daily[50:51]<-daily[51]/2  #something weird with this day, assume
#lag in reporting combining two days
#daily[61]<-4789
#daily[62]<-5289

#generation.time is a funtion from the R0 package.
#If no truncation is provided, the distribution is truncated at 99.99 percent probability.
et<-as.numeric(length(daily))
R.vals.Ital<-est.R0.TD(daily,mGT,begin=40,end=et-1)

#Plot the results
Cairo(5, 5, units="in", type="png", bg="white", dpi = 300, file="Italy's R(t).png") # creates a nice .png
plot(R.vals.Ital$R,xaxt='n',xlab="",ylim=c(0,max(R.vals.Ital$conf.int[2])+0.1),
     ylab="R(t)",type='l',col="blue",cex.axis=0.8)
mtext("Italy\nCOVID-19 Effective Reproduction Number (R(t))", side = 3, line = 1, cex=1, col="black", font=2)
abline(h=1,col="gray80",lty=3)
y<-cbind(R.vals.Ital$R, R.vals.Ital$conf.int[2], R.vals.Ital$conf.int[1])
matshade(seq(1:length(R.vals.Ital$R)), y, lty = 1, col = c("blue","blue","blue"), 
         col.shade=c("blue","blue","blue"), alpha=0.15, plot = dev.cur()==1)
dates <- names(as.data.frame(Italy))[-1]
dates_for_plot<-substr(dates, start = rep(1,length(dates)), stop = nchar(dates)-3)
mtext(side=1,text="Date",line=3,cex=1)
axis(1, at=1:(length(R.vals.Ital$R)), labels=dates_for_plot[(length(dates)-length(R.vals.Ital$R)+1):length(dates)], 
     las=3, cex.axis=0.6)
dev.off()  

#### ITALY ANALYSIS END 
######################################################################

######################################################################
#### HUBEI ANALYSIS START

#Wuhan Data
Wuhan<-full.data%>%filter(`Province/State`=="Hubei")%>%
  dplyr::select(-`Province/State`,-`Country/Region`,-Lat,-Long)
vec<-as.numeric(Wuhan)
daily<-diff(vec)+1
daily[21:22]<-daily[22]/2
daily[31:32]<-daily[31]/2
daily[6:7]<-daily[6]/2
et<-as.numeric(length(daily))
R.vals.Wuh<-est.R0.TD(daily,mGT,begin=3,end=et-1)

#Plot the results
Cairo(5, 5, units="in", type="png", bg="white", dpi = 300, file="Hubei Province's R(t).png") # creates a nice .png
plot(R.vals.Wuh$R,xaxt='n',xlab="",ylim=c(0,max(R.vals.Wuh$conf.int[2])+0.1),
     ylab="R(t)",type='l',col="blue",cex.axis=0.8)
mtext("Hubei Province\nCOVID-19 Effective Reproduction Number (R(t))", side = 3, line = 1, cex=1, col="black", font=2)
abline(h=1,col="gray80",lty=3)
y<-cbind(R.vals.Wuh$R, R.vals.Wuh$conf.int[2], R.vals.Wuh$conf.int[1])
matshade(seq(1:length(R.vals.Wuh$R)), y, lty = 1, col = c("blue","blue","blue"), 
         col.shade=c("blue","blue","blue"), alpha=0.15, plot = dev.cur()==1)
dates <- names(as.data.frame(Wuhan))[-1]
dates_for_plot<-substr(dates, start = rep(1,length(dates)), stop = nchar(dates)-3)
mtext(side=1,text="Date",line=3,cex=1)
axis(1, at=1:(length(R.vals.Wuh$R)), labels=dates_for_plot[(length(dates)-length(R.vals.Wuh$R)+1):length(dates)], 
     las=3, cex.axis=0.6)
dev.off()  
 
#### HUBEI ANALYSIS END 
######################################################################

######################################################################
#### OC PROJECTION ANALYSIS START


#############
#From Italy
R0.Ital<-R.vals.Ital$R
N<-Population
OC.proj.IT<-data.frame(time=0,S=N-Exposed.init-Infected.init,E=Exposed.init,I=Infected.init)
for (j in 1:length(R0.Ital)){
  #SEIR Model
  #Parameter Values
  
  parameters_values <- c(
    N = N, #Total Population
    R0 = as.numeric(R0.Ital[j]), #R0 value
    DI = 8, #Infectious Period
    DE = 5 #Incubation Period
  )
  seir_equations <- function(time, variables, parameters) {
    with(as.list(c(variables, parameters)), {
      dS <- -S/N*(R0/DI*I)
      dE <- S/N*(R0/DI*I)-E/DE
      dI <-  E/DE-I/DI
      return(list(c(dS, dE,dI)))
    })
  }
  Exposed<-OC.proj.IT[j,]$E
  Infected<-OC.proj.IT[j,]$I
  initial_values <- c(
    S = N-Exposed-Infected, # number of susceptibles at time = 0
    E = Exposed, # number of exposed at time = 0
    I = Infected # number of infectious at time = 0
  )
  time_values <- seq((j-1), j)
  sir_values_1 <- ode(
    y = initial_values,
    times = time_values,
    func = seir_equations,
    parms = parameters_values 
  )
  OC.proj.IT[(j+1),]<-sir_values_1[2,]
  N<-as.numeric(sir_values_1[2,2]+sir_values_1[2,3]+sir_values_1[2,4])
  
  # print(parameters_values[[2]])
} #end for loop

#########
#Add in the number of recovered, allowing for the use of the total case count

Recovered <- Population-(rowSums(OC.proj.IT[,2:4])) # Calculate the number of recovered, using the fact that N = S + E + I + R
#OC.proj.IT$I <- OC.proj.IT$I + OC.proj.IT$E + Recovered
OC.proj.IT$I <- OC.proj.IT$I + Recovered
#########

#projects the Estimated Actual Cases [what the hospitals would report if ALL infections were confirmed] 
#in Orange County, NY if OC follows the estimated R(t) of Italy 
OC.proj.IT<-OC.proj.IT %>% mutate(legend="Estimated Actual Cases",dates=seq(from = lubridate::today()-k, to = lubridate::today()+j-k, 
  by = 'day'))%>% dplyr::select(-S,-E)

#projects the Estimated Reported Cases [what the hospitals will likely report as not ALL infections will be confirmed] 
#in Orange County, NY if OC follows the estimated R(t) of Italy 
OC.proj.IT.obs<-data.frame(time=OC.proj.IT$time,I=OC.proj.IT$I/4,legend="Estimated Reported Cases",dates=seq(from = lubridate::today()-k, to = lubridate::today()+j-k, by = 'day'))

#group the results
OC.IT.tot<-rbind(OC.proj.IT,OC.proj.IT.obs)

#############
#From China
N<-Population
R0.Wuh<-R.vals.Wuh$R
OC.proj.CH<-data.frame(time=0,S=N-Exposed.init-Infected.init,E=Exposed.init,I=Infected.init)
for (j in 1:length(R0.Wuh)){
  #SEIR Model
  #Parameter Values
  parameters_values <- c(
    N = N, #Total Population
    R0 = as.numeric(R0.Wuh[j]), #R0 value
    DI = 8, #Infectious Period
    DE = 5 #Incubation Period
  )
  seir_equations <- function(time, variables, parameters) {
    with(as.list(c(variables, parameters)), {
      dS <- -S/N*(R0/DI*I)
      dE <- S/N*(R0/DI*I)-E/DE
      dI <-  E/DE-I/DI
      return(list(c(dS, dE,dI)))
    })
  }
  Exposed<-OC.proj.CH[j,]$E
  Infected<-OC.proj.CH[j,]$I
  initial_values <- c(
    S = N-Exposed-Infected, # number of susceptibles at time = 0
    E = Exposed, # number of exposed at time = 0
    I = Infected # number of infectious at time = 0
  )
  time_values <- seq((j-1), j)
  sir_values_1 <- ode(
    y = initial_values,
    times = time_values,
    func = seir_equations,
    parms = parameters_values 
  )
  OC.proj.CH[(j+1),]<-sir_values_1[2,]
  N<-as.numeric(sir_values_1[2,2]+sir_values_1[2,3]+sir_values_1[2,4])
  
  #print(parameters_values[[2]])
} #end for loop

#########
#Add in the number of recovered, allowing for the use of the total case count
Recovered <- Population-(rowSums(OC.proj.CH[,2:4])) # Calculate the number of recovered, using the fact that N = S + E + I + R
#OC.proj.CH$I <- OC.proj.CH$I + OC.proj.CH$E + Recovered
OC.proj.CH$I <- OC.proj.CH$I + Recovered
#########

#projects the Estimated Actual Cases [what the hospitals would report if ALL infections were confirmed] 
#in Orange County, NY if OC follows the estimated R(t) of Hubei Province 
OC.proj.CH<-OC.proj.CH %>% mutate(legend="Estimated Actual Cases",dates=seq(from = lubridate::today()-k, to = lubridate::today()+j-k,                                                                          by = 'day'))%>% dplyr::select(-S,-E)

#projects the Estimated Reported Cases [what the hospitals will likely report as not ALL infections will be confirmed] 
#in Orange County, NY if OC follows the estimated R(t) of Hubei Province 
OC.proj.CH.obs<-data.frame(time=OC.proj.CH$time,I=OC.proj.CH$I/4,legend="Estimated Reported Cases",dates=seq(from = lubridate::today()-k, to = lubridate::today()+j-k, by = 'day'))

#group the results
OC.CH.tot<-rbind(OC.proj.CH,OC.proj.CH.obs)

#############
#ingest the observed reported cases data 
OC.obs<-test.data<-us.data%>%filter(`County Name` == county & State == state)
OC.df<-data.frame(dates=seq(from = lubridate::today()-k, to = lubridate::today(), by = 'day'),
  I=as.numeric(OC.obs[(ncol(OC.obs)-k):ncol(OC.obs)]),group=NA,legend="Observed Reported Cases")

#############
#plot the results
colors <- c("Projected Actual Cases (Italy)" = "green4", "Projected Reported Cases (Italy)" = "green4", 
  "Projected Actual Cases (Hubei)" = "red2", "Projected Reported Cases (Hubei)" = "red2", 
  "Observed Reported Cases" = "black")
#Cairo(7, 5, units="in", type="png", bg="transparent", dpi = 300, file="OC COVID-19 Projections 2.png") # creates a nice .png
ggplot() +
  ggtitle(label = paste0("Projected Number of COVID-19 Cases in ",county,",",state),
          subtitle = "Using the Estimated R(t)s from Italy and China's Hubei Province") +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, face = "italic")
  ) +
  geom_line(aes(x=dates,y=I,color="Projected Actual Cases (Italy)"), OC.IT.tot[1:nrow(OC.proj.IT),], lwd=1, lty=2) +
  geom_line(aes(x=dates,y=I,color="Projected Reported Cases (Italy)"), OC.IT.tot[nrow(OC.proj.IT)+1:nrow(OC.IT.tot),], lwd=1) +
  geom_line(aes(x=dates,y=I,color="Projected Actual Cases (Hubei)"), OC.CH.tot[1:nrow(OC.proj.IT),], lwd=1, lty=2) +
  geom_line(aes(x=dates,y=I,color="Projected Reported Cases (Hubei)"), OC.CH.tot[(nrow(OC.CH.tot)/2+1):(nrow(OC.CH.tot)/2+nrow(OC.proj.IT)),], lwd=1) +
  geom_point(aes(x=dates,y=I,color="Observed Reported Cases"), OC.df,size=2.5) +
  labs(y="Number of Infected Personnel",x="Date",color="Legend") +
  theme(legend.position = "bottom") +
  scale_color_manual(values = colors) +
  theme(legend.text=element_text(size=8)) +
  guides(colour = guide_legend(override.aes = list(shape = c(16,NA,NA,NA,NA),
     linetype = (c(0,2,2,1,1))), nrow=3, byrow=TRUE)) +
  scale_x_date(breaks = pretty_breaks(10)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) 
#dev.off()



