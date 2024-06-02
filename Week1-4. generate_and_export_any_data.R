# Goal: Show how to save data in various formats
# Author: Minghong SHEN
# Date: 2024-05-24
# Last update: 2024-05-25
# Import: None
# Export: Numerous formats of the sample data


# You are free to use, modify, and distribute this script for educational purposes.
# Commercial use is prohibited without permission.


# ===========================================================
################ Install necessary packages ################
# ===========================================================

# The following packages are required to run this script.
# You can install them by uncommeting and running the following code:

# install.packages(
#   c(
#     "tidyverse", "openxlsx", "haven", "arrow", "jsonlite",
#     "htmlTable", "officer", "flextable", "kableExtra"
#   )
# )

# ===========================================================
##################### Create sample data #####################
# ===========================================================

library(tidyverse)

# This script shows how to save data in various formats.
# The sample data is a tibble with 10 rows and 4 columns.
set.seed(20240524)
tb <- tibble(
  a = 1:1e3,
  b = rnorm(1e3),
  c = rep(c("A", "B"), 5e2),
  d = as.Date("2020-01-01") + 0:999
)

tb

# ===========================================================
################ Prepare the output folder ################
# ===========================================================

getwd()

# Set the output folder
out_folder <- getwd() |>
  file.path("Sample Data")
out_folder # Data will be saved in this folder

# Create the folder if it does not exist
if (!dir.exists(out_folder)) {
  dir.create(out_folder)
}


# ===========================================================
################ Save data in various formats ################
# ===========================================================

# Usually I don't use setwd(), but it is useful here.
setwd(out_folder)

# Save in R data formats
save(tb, file = "sample_data.RData")
library(readr)
write_rds(tb, "sample_data.rds")

# Save as Excel
library(openxlsx)
write.xlsx(tb, "sample_data.xlsx")

# Save as SPSS, Stata, and SAS
library(haven)
write_sav(tb, "sample_data.sav")
write_dta(tb, "sample_data.dta")
write_xpt(tb, "sample_data.sas7bdat") # for SAS

# Save as CSV, TSV, and TXT
library(readr)
write_csv(tb, "sample_data.csv")
library(vroom)
vroom_write(tb, "sample_data.tsv")
vroom_write(tb, "sample_data.txt", delim = "\t")

# Zip a file
zip(zipfile = "sample_data_csv", files = "sample_data.csv")
zip(zipfile = "sample_data_tsv", files = "sample_data.tsv")

# Directly save as compressed format
library(vroom)
vroom_write(tb, "sample_data.tsv.gz")
vroom_write(tb, "sample_data.tsv.bz2")
vroom_write(tb, "sample_data.tsv.xz")

# Save as binary format (not human-readable)
# This is useful for saving large datasets
library(arrow)
write_feather(tb, "sample_data.ftr")

# Save as JSON or HTML
library(jsonlite)
write_json(tb, "sample_data.json")

htmlTable::htmlTable(tb) |>
  as.character() |>
  writeLines("sample_data.html")
library(flextable)
as_flextable(tb)

# Directly print the data and save the output
print(tb) |>
  capture.output() |>
  writeLines("sample_data_console.txt")

# Save as Word
library(officer)
library(flextable)
read_docx() %>%
  body_add_flextable(value = flextable::qflextable(tb)) %>%
  print(target = "sample_data.docx")

# Save as LaTeX or Markdown
library(kableExtra)
tb %>%
  kable("latex") |>
  writeLines("sample_data.tex")

# Save as Markdown
tb %>%
  kable("markdown") |>
  writeLines("sample_data.md")


# ===========================================================
################ Advanced data export techniques #############
# ===========================================================

# In a big project, using setwd() is not recommended.
# Instead, you can specify the full path when saving the data.

# For example, to save the data as an Excel file:
path <- file.path(out_folder, "sample_data.xlsx")
path # Check the full path. This step is optional.
write.xlsx(tb, path)
