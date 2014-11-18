library(tseries)

n <- 150

rdata <- function(n, bx = 0.8, by = 0.8, coef = 0) {
    x <- numeric(n)
    y <- numeric(n)
    for (i in 2:n) {
        x[i] <- bx * x[i-1] + rnorm(1)
        y[i] <- coef * x[i] + by * y[i-1] + rnorm(1)
    }
    data.frame(x, y)
}

mc_stat <- replicate(2000, {
    d <- rdata(150)
    m <- lm(y ~ x, d)
    c(x = unname(m$coef["x"]),
      t = summary(m)$coef["x", "t value"])})

hist(mc_stat["x",], 50, col = "alice blue")
hist(mc_stat["t",], 50, col = "alice blue")
mean(abs(mc_stat["t",]) > 1.65)

mc_unitcrit <- replicate(2000, {
    d <- rdata(150, 1, 1)
    summary(lm(y ~ x, d))$coef["x", "t value"]})
unitcrit <- quantile(mc_unitcrit, c(0.05, 0.95))
mean(mc_stat["t",] < unitcrit[1] | mc_stat["t",] > unitcrit[2])

eps <- 0.0001

## could repeat 2000 times too...
d <- rdata(150)
m <- lm(y ~ x, d)
rxhat <- summary(lm(x[2:n] ~ x[1:(n-1)], d))$coef[2,"t value"]
ryhat <- summary(lm(y[2:n] ~ y[1:(n-1)], d))$coef[2,"t value"]
bquants <- sapply(seq(.7, 1, 0.05), function(rx) {
    sapply(seq(.7, 1, 0.05), function(ry) {
        ex <- d$x[-1] - rx * d$x[1:(n-1)]
        ey <- d$y[-1] - ry * d$y[1:(n-1)]
        tboots <- replicate(199, {
            xboot <- numeric(n)
            yboot <- numeric(n)
            iboot <- sample(1:(n-1), replace = TRUE)
            for (i in 2:n) {
                xboot[i] <- rx * xboot[i-1] + ex[iboot[i-1]]
                yboot[i] <- ry * yboot[i-1] + ey[iboot[i-1]]
            }
            rxboot <- summary(lm(xboot[2:n] ~ xboot[1:(n-1)]))$coef[2,"t value"]
            ryboot <- summary(lm(yboot[2:n] ~ yboot[1:(n-1)]))$coef[2,"t value"]
            cboot <- summary(lm(yboot ~ xboot))$coef["xboot", "t value"]
            c(rx = rxboot, ry = ryboot, b = cboot)})
        rxquant <- quantile(tboots["rx",], c(eps, 1 - eps))
        ryquant <- quantile(tboots["ry",], c(eps, 1 - eps))
        if (rxhat <= rxquant[2] && rxhat >= rxquant[1] &&
            ryhat <= ryquant[2] && ryhat >- ryquant[1]) {
            quantile(tboots["b",], c(0.05 + eps, 0.95 - eps))
        } else {
            c(NA, NA)
        }
    })})
range(bquants, na.rm = TRUE)            

mean(mc_stat["t",] < min(bquants, na.rm = TRUE) |
     mc_stat["t",] > max(bquants, na.rm = TRUE))
