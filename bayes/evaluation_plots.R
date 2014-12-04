library(magrittr)
L <- function(e) ifelse(e < 1/200, 10 * e^2, e / 10 - 1/4000)
curve(L, -.1, .1, lwd = 2)

L <- function(e) e^2

n <- 25
s <- 20

dprior <- function(theta) dunif(theta)
likelihood <- function(s, n, theta) dbinom(s, n, theta)

kernfn <- function(theta, theta_hat)
    L(theta - theta_hat) * dprior(theta) * likelihood(s, n, theta)

riskfn <- function(theta_hat)
    integrate(function(th) kernfn(th, theta_hat),
              lower = 0, upper = 1)$value

L <- function(e) abs(e)
optimize(riskfn, lower = 0, upper = 1)
Vectorize(riskfn) %>% curve(from = 0, to = 1, lwd = 2)

th <- rbeta(10000, s + 1, n - s + 1)
riskmc <- function(theta_hat) mean(L(th - theta_hat))
optimize(riskmc, lower = 0, upper = 1)
Vectorize(riskmc) %>% curve(from = 0, to = 1, lwd = 2, col = "red")
