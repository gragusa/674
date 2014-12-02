## Basic naive priors for autoregressions
runit <- function(n, b = 1) {
    ex <- rnorm(n)
    x <- numeric(n)
    for (i in 2:n) {
        x[i] <- b * x[i-1] + ex[i]
    }
    x
}

`%∈%` <- function(a, b) a >= b[1] & a <= b[2]
naive_prior <- function(n, rx = 1, ry = 1, nsims = 1000)
    replicate(nsims, {
        x <- runit(n, rx)
        y <- runit(n, ry)
        m <- lm(y[-1] ~ y[-n] + x[-n])
        c(ylag = ry %∈% confint(m, "y[-n]"),
          xlag = 0  %∈% confint(m, "x[-n]"))})
## Not a rousing endorsement of using the basic normal prior
rowMeans(naive_prior(250, 1, 1))

naive_diff <- function(n, rx = 1, ry = 1, nsims = 1000, level = 0.95)
    replicate(nsims, {
        x <- runit(n, rx)
        y <- runit(n, ry)
        m <- lm(I(y[-1] - y[-n]) ~ x[-n])
        0 %∈% confint(m, "x[-n]", level)})

## Oh, this one works!
mean(naive_diff(250, 1, 1))
## But not when ry ≠ 1. Now we have massive overcoverage
mean(naive_diff(250, 1, .95))
mean(naive_diff(250, 1, .95, level = 0.5))

## Berger-Yang 'noninformative 'priors' for AR(1)
## Assumes zero mean, known variance, x[1] == 0
djeff <- function(ρ, n)
    sqrt( n/(1-ρ^2) + ( (1-ρ^(2*n)) / (1-ρ^2) ) * (1 - 1/(1-ρ^2)) )
dsymm <- function(ρ)
    1 / (2*pi * ifelse(abs(ρ) < 1, sqrt(1 - ρ^2), abs(ρ) * sqrt(ρ^2 - 1)))
dar <- function(y, ρ)
    sapply(ρ, function(ρj)
        prod(sapply(2:length(y), function(i) dnorm(y[i], ρj*y[i-1]))))

credset <- function(prior, likelihood, α = 0.05) {
    xpoints <- seq(-1.2, 1.2, length.out = 2500)
    post <- prior(xpoints) * likelihood(xpoints)
    post <- post / sum(post)
    Fpost <- cumsum(post)
    xpoints[c(max(which(Fpost < α/2)),
              min(which(Fpost > 1 - α/2)))]
}

dosims <- function(n, ρ, nsims = 1000, α = 0.05)
    replicate(nsims, {
        y <- runit(n, ρ)
        c(jeff = ρ %∈% credset(function(p) djeff(p, n), function(p) dar(y, p), α),
          symm = ρ %∈% credset(function(p) dsymm(p), function(p) dar(y, p), α),
          flat = ρ %∈% credset(function(p) p %∈% c(-1,1), function(p) dar(y, p), α))})

## Let's see if they work!
mc1 <- dosims(200, 0.3, 500)
mc2 <- dosims(150, 0.8)
mc3 <- dosims(150, 0.95)
mc4 <- dosims(150, 1)
rowMeans(mc1)
rowMeans(mc2)
rowMeans(mc3)
rowMeans(mc4)
