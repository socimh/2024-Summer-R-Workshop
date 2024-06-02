
Sys.setenv(R_INSTALL_STAGED = FALSE)
devtools::install_github("socimh/statart")

library(statart)

?statart

library(tidyverse)
starwars %>%
  select(-c(1:3))
