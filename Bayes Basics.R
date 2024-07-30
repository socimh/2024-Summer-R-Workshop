
pacman::p_load(
  tidyverse, statart,
  broom, broom.mixed,
  MCMCpack, rstan, rstanarm
)

########## 网店好评率问题 ##########

# Frequentist approach
# H0: 50% Good
.5*.5*.5*.5*.5 # < 0.05

# Reject the null hypothesis
# Conclusion: > 50% Good!


# Bayesian approach
beta_plot <- function(alpha, beta) {
  tibble(
    x = seq(0, 1, by = .01),
    y = dbeta(x, alpha, beta)
  ) %>%
    ggplot() +
    geom_ribbon(
      aes(x, ymin = 0, ymax = y),
      color = "black", lwd = 1,
      fill = "lightgrey"
    ) +
    scale_x_continuous(
      breaks = seq(0, 1, by = .2)
    ) +
    coord_cartesian(
      xlim = c(0, 1)
    ) +
    labs(title = str_glue("Beta({alpha}, {beta})"),
         x = "Good Rate",
         y = "Density") +
    theme_bw()
}

# uniform (noninformative) prior
beta_plot(1, 1)

# data: 5 good, 1 bad
beta_plot(6, 1)

# data: 90 good, 10 bad
beta_plot(91, 11)
beta_plot(96, 11) # add 5 good

# data: 900 good, 100 bad
beta_plot(901, 101)

# data: 9000 good, 1000 bad
beta_plot(9001, 1001)


########## 贝叶斯模型 ##########
nrow(diamonds)

ols <- lm(price ~ carat + depth + table, data = diamonds)
tidy(ols)

# MCMC: Markov Chain Monte Carlo
# Numerical methods (扔飞镖，一个个尝试)
# 1e-4 = 0.0001, 1e4 = 10000
bayes0 <- MCMCregress(
  price ~ carat + depth + table, data = diamonds,
  b0 = 0, # Prior mean
  B0 = 1e-8 # Prior precision (inverse of variance)
)

summary(bayes0)
tidy(bayes0)

select <- dplyr::select
tidy(ols) %>%
  full_join(
    tidy(bayes0),
    by = "term",
    suffix = c("_ols", "_bayes")
  ) %>%
  select(term, estimate_ols, estimate_bayes)


bayes1 <- MCMCregress(
  price ~ carat + depth + table, data = diamonds,
  b0 = 100, # Prior mean
  B0 = 1e-8 # Prior precision (inverse of variance)
)

tidy(bayes0) %>%
  full_join(
    tidy(bayes1),
    by = "term",
    suffix = c("_bayes0", "_bayes1")
  ) %>%
  select(term, s_match("estimate*"))


bayes2 <- MCMCregress(
  price ~ carat + depth + table, data = diamonds,
  b0 = 0, # Prior mean
  B0 = 1 # Prior precision (inverse of variance)
)

tidy(bayes0) %>%
  full_join(
    tidy(bayes2),
    by = "term",
    suffix = c("_bayes0", "_bayes2")
  ) %>%
  select(term, s_match("estimate*"))


# All 10,000 trials
as_tibble(bayes0)
