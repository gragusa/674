nsims <- 10000
ppost <- rbeta(nsims, 21, 6) ## uniform prior
hist(ppost, 70, col = "alice blue")

preds <- rbinom(nsims, 8, ppost)
hist(preds, col = "red")

100 * table(preds) / nsims
