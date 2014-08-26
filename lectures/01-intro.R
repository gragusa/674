getSymbols("SP500", src="FRED")
s <- SP500

plot(s)
plot(diff(log(s)))
sd <- diff(log(s))

plot(y = as.vector(sd), x = as.vector(lag(sd, -1)))
plot(abs(sd - mean(sd, na.rm=TRUE)))
s2 <- as.vector(abs(sd - mean(sd, na.rm=TRUE)))
plot(lag(s2, -1), s2)
