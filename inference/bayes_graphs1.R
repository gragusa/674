pdf("likelihood1.pdf", 3.5, 2)
par(mar = c(4, 4, 1, 2))
curve(dbinom(20, 25, x), 0, 1)
dev.off()

x <- seq(0, 1, length.out = 1001)
xinc <- x[2] - x[1]
post1 <- dbinom(20, 25, x)
post1 <- post1 / sum(post1) / xinc
post2 <- dbinom(21, 27, x)
post2 <- post2 / sum(post2) / xinc
post3 <- dbinom(30, 35, x)
post3 <- post3 / sum(post3) / xinc

pdf("posteriors1.pdf", 3.5, 2)
par(mar = c(4, 4, 1, 2))
plot(post3 ~ x, type = "l", ylab = "", col = "red", xlab = "")
lines(post2 ~ x, col = "blue")
lines(post1 ~ x, col = "black")
dev.off()
