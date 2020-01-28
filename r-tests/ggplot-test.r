rm(list = ls())

obs <- 100
x <- rnorm(obs)
y <- 2 * x + rnorm(obs)
w <- runif(obs)
m <- lm(y ~ x, weights = w)
summary(m)

result <- local({
  x <- rnorm(obs)
  y <- rnorm(obs)
  (x + y) * w
})

fun <- function(var1, var2) {
  if (var1 > var2) {
    var3 <- var1 + var2
    var4 <- 1 + 2
    for (var5 in 1:10) {
       var1 + var2 + var3 + var4 + var5
    }
  } else {
    var1 - y
  }
}

fun(10, var2 = 20)

plot(rnorm(250))