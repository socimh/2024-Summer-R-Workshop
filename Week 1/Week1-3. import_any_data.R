# Goal: Show how to read data from various formats
# Author: Minghong SHEN
# Date: 2024-05-25
# Last update: 2024-05-25
# Import: Numerous formats of the sample data
# Export: None


# You are free to use, modify, and distribute this script for educational purposes.
# Commercial use is prohibited without permission.

# ===========================================================
################ Install necessary packages ################
# ===========================================================

# The following packages are required to run this script.
# You can install them by uncommeting and running the following code:

# install.packages(
#   c(
#     "readr", "readxl", "haven", "vroom", "arrow",
#     "jsonlite", "rvest"
#   )
# )

# ===========================================================
################## Locate the data folder ##################
# ===========================================================

getwd()

# This is the data folder on my computer
# You should change it to your own folder
# You can type the directory manually or use file.choose()
data_folder <- getwd() |>
  file.path("Sample Data")


# ===========================================================
##################### Read sample data #####################
# ===========================================================

# Usually I don't use setwd(), but it is useful here.
setwd(data_folder)

# Read from R data formats
load("sample_data.RData")
library(readr)
tb <- read_rds("sample_data.rds")

# Read from Excel
library(readxl)
tb <- read_excel("sample_data.xlsx")

# Read from SPSS, Stata, and SAS
library(haven)
tb <- read_sav("sample_data.sav")
tb <- read_dta("sample_data.dta")
tb <- read_sas("sample_data.sas7bdat")

# Read from CSV, TSV, and TXT
library(vroom)
tb <- vroom("sample_data.csv")
tb <- vroom("sample_data.tsv")
tb <- vroom("sample_data.txt", delim = "\t")

# Unzip and read a file
library(vroom)
tb <- unz("sample_data.zip", "sample_data.csv") |>
  vroom()

# Read from compressed format
library(vroom)
tb <- vroom("sample_data.tsv.gz")
tb <- vroom("sample_data.tsv.bz2")
tb <- vroom("sample_data.tsv.xz")

# Read from Feather
library(arrow)
tb <- read_feather("sample_data.ftr")

# Read from JSON or HTML
library(jsonlite)
tb <- fromJSON("sample_data.json")

library(tidyverse) # for the pipe operator %>%
library(rvest)
tb <- read_html("sample_data.html") |>
  html_table() %>%
  .[[1]]



# ===========================================================
################ Standard data import techniques #############
# ===========================================================

# In a big project, using setwd() is not recommended.
# Instead, you can specify the full path when saving the data.

# For example, to save the data as an Excel file:
path <- file.path(data_folder, "sample_data.xlsx")
path # Check the full path. This step is optional.

tb <- read_excel(path)
