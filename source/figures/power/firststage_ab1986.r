#devtools::install_github("jonathandroth/pretrends")

library(pretrends)

#Load the coefficients, covariance matrix, and time periods
beta <- unlist(read.csv("coefficients_1986ab.csv"))
sigma <- as.matrix(read.csv("var_cov_1986ab.csv"))
tVec <- c(-2, -1, 0, 1, 2, 3, 4, 5, 6)
referencePeriod <- 0 #This is the omitted period in the regression
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

#df_power shows stats about power of pre-test against hypothesized trend
pretrendsResults$df_power

pretrendsResults$event_plot_pretest
