# ================== Week 1 Assignment ==================#

# Question setter: Minghong SHEN
# Release date: 2024-06-04
#
# Test taker (名字): 沈明宏
# Import: nlsw88.dta
# Export: who.csv, nlsw88.csv
# Completion date: 2024-06-11

# QUESTION 0. Get Copilot ready in your RStudio or VS Code.



# ================== Question Set ==================#
# 对于问题1-3，写代码就可以了，不需要回答。

###### Load the necessary packages ######
# QUESTION 1. Load tidyverse and statart packages
library(tidyverse)
library(statart)

# alternatively,
pacman::p_load(tidyverse, statart)


###### Load WHO data ######
# QUESTION 2. Print the built-in dataset of tidyverse "who".
# QUESTION 2a. How many rows and columns are there in the dataset "who"?
# QUESTION 2b. What is the dominant column type (e.g., character, numeric)?
# QUESTION 2c. Store the data in csv format.

# Question 2a
data(who)
who
nrow(who)
ncol(who)
dim(who)

# Question 2b
view(codebook(who))
print(codebook(who), n = 60)
print(codebook(who), n = Inf)
print_interval(codebook(who))

tab(codebook(who), type)

glimpse(who)

# Question 2c
path <- "D:/R/Teaching/2024 Summer R Workshop/Week 1/Week 1 Assignment/who.csv"
write_csv(who, path)
write_data(who, path)


###### Import NLSW 1988 Data ######
# QUESTION 3. Import the dataset "nlsw88.dta" as "nlsw88"
path <- "D:/R/Teaching/2024 Summer R Workshop/Week 1/Week 1 Assignment/nlsw88.dta"
nlsw88 <- haven::read_dta(path)
nlsw88 <- haven::read_data(path)


# QUESTION 3a. Among the last 5 individuals, what is the average age?
print_headtail(nlsw88)

tail(nlsw88, 5)

(35 + 44 + 42 + 38 + 43) / 5
c(35, 44, 42, 38, 43) %>% mean()
tail(nlsw88, 5) %>%
  summarise(mean(age))


# QUESTION 3b. What is the meaning of variable "ttl_exp"?
codebook(nlsw88)
codebook(nlsw88) %>%
  slice(16) %>%
  pull(label)

variables(nlsw88)

# QUESTION 3c. Now I have sorted the dataset by wage.
# How to quickly pick 10 individuals from different wage levels
# and view their characteristics?

nlsw88 <- arrange(nlsw88, wage)
print_interval(nlsw88)

# QUESTION 3d. Store the data in another format that you like.



###### Formatting ######
# QUESTION 4. It is always a good idea to write something in the header.
# Complete the header lines (line 6-9) in the script.
