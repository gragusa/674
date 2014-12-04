library(MCMCpack)
library(quantmod)
u <- getSymbols("UNRATE", src="FRED", auto.assign = FALSE)
names(d) <- "u"

rfuture <- function(n, unemp, state, transition, param) {
    r <- matrix(0, 2, n)
    r[1,1] <- sample(1:2, 1, prob = transition[tail(state,1),])
    r[2,1] <- rnorm(1, param[1,r[1,1]], param[2,r[1,1]])
    for (i in 2:n) {
        r[1,i] <- sample(1:2, 1, prob = transition[r[1,i-1],])
        r[2,i] <- rnorm(1, param[1,r[1,i]], param[2,r[1,i]])
    }
    r
}

## Generate S_t given data, parameters, and old state
rstate <- function(unemp, transition, param, state) {
    n <- length(state)
    eigens <- eigen(t(transition))
    invariants <- eigens$vectors[,eigens$values == 1]
    invariants <- invariants / sum(invariants)
    
    state[1] <- sample(1:2, 1, prob = sapply(1:2, function(s)
        transition[s,state[2]] * invariants[s] *
                                   dnorm(unemp[1], param[1,s], param[2,s])))
    for (i in 2:(n-1)) {
        state[i] <- sample(1:2, 1, prob = sapply(1:2, function(s)
            transition[state[i-1], s] * transition[s, state[i+1]] *
                dnorm(unemp[i], param[1,s], param[2,s])))
    }
    state[n] <- sample(1:2, 1, prob = sapply(1:2, function(s)
        transition[state[n-1], s] * dnorm(unemp[n], param[1,s], param[2,s])))
    state
}

## Generate mean and variance of unemployment process given the data
## and a hypothetical sequence of S_t
rmeansd <- function(unemp, state) {
    counts <- sapply(1:2, function(s) sum(state == s))
    avg <- sapply(1:2, function(s) mean(unemp[state == s]))
    ## Set the variance the same in each period
    sig <- sqrt(rinvgamma(1, sum(counts) / 2,
                          drop(crossprod(unemp - avg[state])) / 2))
    repeat {
        avgs <- rnorm(2, avg, sig / sqrt(counts))
        if (avgs[1] > avgs[2]) break
    }
    rbind(avgs, sig)
}

## Generate transition probabilitites given the data and a
## hypothetical sequence of S_t
rtransition <- function(unemp, state) {
    transition_count <- matrix(1, 2, 2)
    for (i in 2:length(state))
        transition_count[state[i-1], state[i]] <-
            transition_count[state[i-1], state[i]] + 1
    transition <- matrix(NA, 2, 2)
    transition[,1] <- c(rbeta(1, 1 + transition_count[1,1], 1 + transition_count[1,2]),
                        rbeta(1, 1 + transition_count[2,1], 1 + transition_count[2,2]))
    transition[,2] <- 1 - transition[,1]
    transition
}

medfilt <- function(x, runs = 1) {
    n <- length(x)
    for (i in 1:runs) {
        x <- sapply(1:n, function(i) median(x[max(1, (i-2)):min(n, i+2)]))
    }
    x
}

## Here's where the main program starts
unemp <- diff(qnorm(u / 100))[-1]

nsims <- 2000
## Start with an initial guess of the recessions
state_0 <- ifelse(medfilt(unemp, 10) > 0, 1, 2)

## Initialize matrices that will store the draws of parameters and states
states <- matrix(nrow = nsims, ncol = length(unemp))
transitions <- matrix(nrow = nsims, ncol = 4)
transitions[1,] <- c(rtransition(unemp, state_0))
params <- matrix(nrow = nsims, ncol = 4)
params[1,] <- c(rmeansd(unemp, state_0))
states[1,] <- rstate(unemp, matrix(transitions[1,], 2,2),
                     matrix(params[1,],2,2), state_0)

## Loop to implement the Gibbs sampler. Don't I wish R were faster...
for (i in 2:nsims) {
    transitions[i,] <- c(rtransition(unemp, states[i-1,]))
    params[i,] <- c(rmeansd(unemp, states[i-1,]))
    states[i,] <- rstate(unemp, matrix(transitions[i,], 2,2),
                         matrix(params[i,],2,2), states[i-1,])
}

plot(ts(cbind(u[-1],
              "Recession Prob" = 2 - colMeans(states[501:nsims,])),
        start = c(1948,2), frequency = 12),
     main = NA)

hist(params[501:nsims,c(1,3)], 40, main = "Posterior unemployment trends")
plot(params[501:nsims,c(1,3)], main = "Posterior unemployment trends",
     xlab = "Recession mean", ylab = "Expansion mean")
hist(params[501:nsims,2], 40, main = "Posterior unemployment volatility")

## Predictions
npred <- 12
fstates <- matrix(nrow = nsims - 500, ncol = npred)
funemps <- matrix(nrow = nsims - 500, ncol = npred)
for (i in 1:(nsims - 500)) {
    isim <- 500 + i
    forecasts_i <- rfuture(npred, unemp, states[isim,], matrix(transitions[isim,], 2, 2),
                           matrix(params[isim,], 2, 2))
    fstates[i,] <- forecasts_i[1,]
    funemps[i,] <- forecasts_i[2,]
}

hist(5.8 + funemps[,1], 30, main = "November unemployment forecast")
mean(5.8 + funemps[,1])
