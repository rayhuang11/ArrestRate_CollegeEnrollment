devtools::install_github("jonathandroth/pretrends")

library(pretrends)

#Load the coefficients, covariance matrix, and time periods
beta <- pretrends::HeAndWangResults$beta
sigma <- pretrends::HeAndWangResults$sigma
tVec <- pretrends::HeAndWangResults$tVec
referencePeriod <- -1 #This is the omitted period in the regression
data.frame(t = tVec, beta = beta)

#Compute slope that gives us 50% power
slope50 <-
  slope_for_power(sigma = sigma,
                  targetPower = 0.5,
                  tVec = tVec,
                  referencePeriod = referencePeriod)
slope50

pretrendsResults <- 
  pretrends(betahat = beta, 
            sigma = sigma, 
            tVec = tVec, 
            referencePeriod = referencePeriod,
            deltatrue = slope50 * (tVec - referencePeriod))

pretrendsResults$event_plot

