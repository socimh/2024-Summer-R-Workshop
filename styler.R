# This script is used to automatically format the R scripts.
# install.packages("styler")

# Change to your own folder
folder <- "D:/R/Teaching/2024 Summer R Workshop"
# Run this line to format all R scripts in the folder
styler::style_dir(folder)
