
# ===========================================================
###################### Install Packages ######################
# ===========================================================

# For each version of R, you only need to install the packages once.
# Yet, if you update R, you will need to reinstall the packages.

# install.packages("...") is used to install packages from CRAN
install.packages("tidyverse")

# devtools::install_github("...") is used to install packages from GitHub
install.packages("devtools")
devtools::install_github("socimh/statart")

# Install multiple packages at once
packages <- c("flextable", "officer", "kableExtra")
install.packages(packages)


# ===========================================================
###################### Load Packages ######################
# ===========================================================

# Every time you start a new R session, you may load the packages you need.

# To load a package, I recommend three ways:
# 1. library(...)
library(statart)
library("statart") # This is also correct

# 2. package::function(...)
tibble::tibble(a = 1)

# 3. pacman::p_load(...)
# This is the most convenient way to load multiple packages
pacman::p_load(tidyverse, statart, flextable)


library(tidyverse)
starwars %>%
  select(-c(1:3))
