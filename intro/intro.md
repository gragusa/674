Especially short notes for August 26th introductory lecture
===========================================================

10 min. hand out syllabus and discuss.

? min. look at some time series

### First, unemployment
~~~ R
library(quantmod)
getSymbols("UNRATENSA", src="FRED")
u <- ts(UNRATENSA, start = c(1948, 1), frequency = 12)

plot(u)
monthplot(u)

## Quick and dirty deseasonalization (not fantastic, though)
u2 <- ts(resid(lm(u ~ factor(rep(1:12, length.out = 799)))) + mean(u))
tsp(u2) <- tsp(u)
plot(u2)
monthplot(u2)

## You can think of this as a model of the seasonality. In more
## complicated scenarios, a more complicated model could be necessary
plot(decompose(u))
plot(decompose(u2))
~~~

### Now GDP
~~~
getSymbols("GDPC1", src="FRED")
y <- ts(GDPC1, start = c(1947, 1), frequency = 4)

plot(y)
plot(log(y))
monthplot(log(y))

x <- 1:270
yh <- cbind(1, x) %*% coef(lm(log(y) ~ x))

plot(log(cbind(log(y), yh)), plot.type = "single",
     col = c("black", "red"))

plot(log(y) - yh)
abline(0, 0, col="red")
plot(log(y) - yh ~ lag(log(y) - yh, -1))

yd <- diff(log(y))
plot(yd)
plot(yd ~ lag(yd, -1))

getSymbols("PCE")
~~~

### Now the SP500

~~~
getSymbols("SP500", src="FRED")
s <- SP500

plot(s)
plot(diff(log(s)))
sd <- diff(log(s))

plot(y = as.vector(sd), x = as.vector(lag(sd, -1)))
plot(abs(sd - mean(sd, na.rm=TRUE)))
s2 <- as.vector(abs(sd - mean(sd, na.rm=TRUE)))
plot(lag(s2, -1), s2)
~~~

* Look at inflation too

