rm(list = ls(all = TRUE))
setwd("D:/R/Teaching/2024 Summer R Workshop/Week 8")
sink("rLabGuide02bayesLinReg.log", split = T)

# load the foreign package
pacman::p_load(
  statart, car,
  MCMCpack, clarify, effects, tidyverse
)
select <- dplyr::select
readin <- read_dta("gssCum7212Teach.dta") # haven

readin
glimpse(readin)

readin %>%
  tab(wrkstat)

readin %>%
  tab1(everything())

mydta <- subset(
  readin,
  race < 3 & (age >= 25 & age <= 65),
  select = c(health, age, educ, impinc, female, white)
)

mydta <- readin %>%
  filter(race < 3 & (age >= 25 & age <= 65)) %>%
  select(health, age, educ, impinc, female, white)


# method 03 to drop missing; drop missing for all variables in the data object
usedta03 <- mydta[complete.cases(mydta), ]

usedta <- mydta %>%
  filter(complete.cases(.))


list(a = 1)
list(a = 1, b = "X")


ols.reg <- lm(
  health ~ age + educ + impinc + female + white,
  data = usedta
)
class(ols.reg)
class(usedta)
typeof(ols.reg)

ols.reg
View(ols.reg)

summary(ols.reg)
confint(ols.reg)

tval <- (coef(ols.reg)[3] - 0.5) / sqrt(vcov(ols.reg)[3, 3])
pval <- 2 * pt(abs(tval), df.residual(ols.reg), lower.tail = FALSE)
c(t = tval, p = pval)

linearHypothesis(ols.reg, c("educ=0.5"))
(hypo <- linearHypothesis(ols.reg, c("educ=0", "age=0")))
linearHypothesis(ols.reg, c("educ=age"))

ols.regNoAge <- lm(health ~ educ + impinc + female + white, data = usedta)
(fTest <- anova(ols.regNoAge, ols.reg))

usedta$healthpr <- predict(ols.reg, type = "response")
summary(usedta$healthpr)

new.data <- data.frame(
  age = 35,
  educ = 16,
  impinc = median(usedta$impinc),
  white = 1,
  female = 1
)
(pr <- predict(ols.reg, newdata = new.data, interval = "confidence"))

set.seed(200124)
sim_coef <- sim(ols.reg)
sim_est <- sim_setx(sim_coef, x = list(
  age = 35,
  educ = 16,
  impinc = median(usedta$impinc),
  white = 1,
  female = 1
), verbose = T)
(simout <- summary(sim_est))

set.seed(200124)
sim_coef <- sim(ols.reg)
sim_dif <- sim_setx(sim_coef,
  x = list(
    age = 35,
    educ = 16,
    impinc = median(usedta$impinc),
    white = 1,
    female = 1
  ),
  x1 = list(
    age = 35,
    educ = 16,
    impinc = median(usedta$impinc),
    white = 1,
    female = 0
  ),
  verbose = T
)
summary(sim_dif)

plot(predictorEffects(ols.reg))

mcmc.reg <- MCMCregress(health ~ age + educ + impinc + female + white,
  data = usedta,
  burnin = 1000,
  mcmc = 10000,
  thin = 1,
  seed = 47306,
  b0 = c(0, 0, 0, 0, 0, 0),
  B0 = c(1e-6, .01, .01, 1.6e-5, 1.6e-5, 1.6e-5),
  marginal.likelihood = "Chib95"
)

(mcmc.sum <- summary(mcmc.reg))

mcmc.regNoAge <- MCMCregress(
  health ~ educ + impinc + female + white,
  data = usedta,
  burnin = 1000,
  mcmc = 10000,
  thin = 1,
  seed = 47306,
  b0 = c(0, 0, 0, 0, 0),
  B0 = c(1e-6, .01, 1.6e-5, 1.6e-5, 1.6e-5),
  marginal.likelihood = "Chib95"
)
(BF <- BayesFactor(mcmc.reg, mcmc.regNoAge))
