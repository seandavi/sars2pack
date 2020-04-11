library(tidyverse)

#Code is produced to parametrically model the effective reproductive
#rate and estimate from data
#Assumption is that effective reproductive rate r_t follows
#an exponential decay function parameterized by time
#Two parameters to be estimated are beta_0, which is r_0
#and beta_1 which yields r_t=\beta_0 \exp(\beta_1 t)
#Model is built off simple discrete SIR model
#Epsilon is in S(t) currently

#JHU Data
us.data<-read_csv("https://static.usafacts.org/public/data/covid-19/covid_confirmed_usafacts.csv?_ga=2.161264510.2114667733.1584890934-1059662301.1584890934")

#Function to find parameters
seir.func<-function(data,pars){
  S0<-data$S0
  DI<-data$DI
  N<-data$N
  I0<-data$I0
  Iobs<-data$Iobs
  beta0<-pars[1]
  beta1<-pars[2]
  tot.obs<-length(Iobs)
  t<-seq(0,tot.obs-1)
  r<-beta0*exp(-beta1*t) #Start with simple structure on r_t
  Sucept<-c()
  Infect<-c()
  Sucept[1]<-S0
  Infect[1]<-I0
  for(i in 2:tot.obs){
    Sucept[i]<- -Sucept[i-1]/N*(r[i-1]/DI*Infect[i-1])+Sucept[i-1]
    Infect[i]<- Sucept[i-1]/N*(r[i-1]/DI*Infect[i-1])-Infect[i-1]/DI+Infect[i-1]
  }
  New.cases<- -diff(Sucept)
  return(sum((New.cases-Iobs[-1])^2)) #Min SSE for Target Function
}



####For NYC


county<-"New York City" 
state<-"NY"
pop<-8623000

###############
#Exposed.init <-5000

if (county == "All Counties" & state == "All States") {
  test.data<-us.data%>%filter(stateFIPS > 0)
  test.data[,1:4]<-0
  test.data <- test.data %>% summarise_all(funs(sum))
} else if (county == "All Counties") {
  test.data<-us.data%>%filter(State == state)
  test.data[,1:4]<-0
  test.data <- test.data %>% summarise_all(funs(sum))
} else if (county == "New York City") {
  test.data<-us.data%>%filter(countyFIPS %in% c(36061,36047,36005,36085,36081))
  test.data[,1:4]<-0
  test.data<-test.data%>%summarise_all(funs(sum))
} else {
  test.data<-us.data%>%filter(`County Name` == county & State == state)
  FIPS_code <- as.numeric(test.data[1])
} 

dat<-test.data %>% dplyr::select(-countyFIPS,-`County Name`,-State,-stateFIPS)


#Assumes outbreak hits on 18 March

test.data<-diff(as.numeric(dat))[57:(length(as.numeric(dat))-1)]
inits<-as.numeric(dat)[57]


result <- optim(par = c(7,.3), fn = seir.func, data = list(S0=pop-inits,DI=8,N=pop,I0=inits,Iobs=test.data),control=list(abstol=.001))

seir.pred.func<-function(data,pars){
  S0<-data$S0
  DI<-data$DI
  N<-data$N
  I0<-data$I0
  Iobs<-data$Iobs
  beta0<-pars[1]
  beta1<-pars[2]
  tot.obs<-length(Iobs)
  t<-seq(0,tot.obs-1)
  r<-beta0*exp(-beta1*t)
  Sucept<-c()
  Infect<-c()
  Sucept[1]<-S0
  Infect[1]<-I0
  for(i in 2:tot.obs){
    Sucept[i]<- -Sucept[i-1]/N*(r[i-1]/DI*Infect[i-1])+Sucept[i-1]
    Infect[i]<- Sucept[i-1]/N*(r[i-1]/DI*Infect[i-1])-Infect[i-1]/DI+Infect[i-1]
  }
  New.cases<- -diff(Sucept)
  return(list(New.cases=New.cases,r=r))
}

gah<-seir.pred.func(data=list(S0=pop-inits,DI=8,N=pop,I0=inits,Iobs=test.data),pars=c(result$par[1],result$par[2]))
gah$New.cases-test.data[-1]
