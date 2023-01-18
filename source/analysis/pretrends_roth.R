devtools::install_github("jonathandroth/pretrends")

library(pretrends)

#Load the coefficients, covariance matrix, and time periods
beta <- c(-159.57987, -142.62841, -72.994561, 116.48307, 216.60878, 339.87964, 0)

sigma <- matrix(c(19451.866, 12441.605, 5325.1719, -1520.1857, -2540.8618, -5247.2621,0,
                  12441.605, 9783.414, 4275.8322, -2165.672, -4300.2952, -6634.0827,0,
                  5325.1719, 4275.8322, 2543.7204, -1111.3112, -2485.4035,-3763.9298,0,
                  -1520.1857,-2165.672,-1111.3112,8866.4137, 12543.886, 13942.985,0,
                  -2540.8618, -4300.2952,-2485.4035, 12543.886, 21874.095, 24929.135,0,
                  -5247.2621, -6634.0827, -3763.9298, 13942.985, 24929.135, 30176.604,0,
                  0,0,0,0,0,0,0)
                , nrow = 7, ncol = 7)
isSymmetric(sigma)
tVec <- c(-4,-3,-2,0,1,2,-1)
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

#df_power shows stats about power of pre-test against hypothesized trend
pretrendsResults$df_power

pretrendsResults$event_plot_pretest
