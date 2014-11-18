n <- 150
rdata <- function(n, bx = 1, bz = 1) {
    x <- rnorm(n)
    z <- x + rnorm(n)
    y <- bx * x + bz * z + rnorm(n)
    data.frame(y, x, z)
}

mc_simple <- replicate(2000, {
    d <- rdata(n, 0, 0.1)
    m <- lm(y ~ x + z, d)
    c(x = unname(m$coef["x"]),
      t = summary(m)$coef["x","t value"])
})

hist(mc_simple["x",], 50, col = "alice blue")
hist(mc_simple["t",], 50, col = "alice blue")
mean(abs(mc_simple["t",]) > 1.65)
mean(mc_simple["x",]^2)

mc_tricky <- replicate(2000, {
    d <- rdata(n, 0, 0.1)
    m <- lm(y ~ x + z, d)
    dropz <- anova(m)["z",5] > 0.10
    if (dropz) m <- update(m, . ~ . -z)
    c(dropz = dropz,
      x = unname(m$coef["x"]),
      t = summary(m)$coef["x","t value"])
})

hist(mc_tricky["x",], 50, col = "alice blue")
hist(mc_tricky["t",], 50, col = "alice blue")
mean(abs(mc_tricky["t",]) > 1.65)
mean(mc_tricky["dropz",])
mean(mc_tricky["x",]^2)
