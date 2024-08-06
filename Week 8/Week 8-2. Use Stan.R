pacman::p_load(
  tidyverse, statart,
  rstan, MCMCpack, rstanarm, brms
)

schools_dat <- list(
  J = 8,
  y = c(28, 8, -3, 7, -1, 1, 18, 12),
  sigma = c(15, 10, 16, 11, 9, 11, 10, 18)
)

fit <- stan(file = "schools.stan", data = schools_dat)
print(fit)


plot(fit)
pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays
mu <- la$mu

### return an array of three dimensions: iterations, chains, parameters
extract(fit, permuted = FALSE)

### use S3 functions on stanfit objects
as.array(fit)
as.matrix(fit)
as.data.frame(fit)
