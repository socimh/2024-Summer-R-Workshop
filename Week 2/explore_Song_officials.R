
# Load the data
# Downloaded from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/KER9GK
# Wang, Yuhua, 2021, "Replication Data for: The Rise and Fall of Imperial China: The Social Origins of State Development. Princeton University Press.", https://doi.org/10.7910/DVN/KER9GK, Harvard Dataverse, V1, UNF:6:L5nJpS44U2P6GvJeR7SThg== [fileUNF]
file <- "C:/Users/socim/Downloads/all song officials vertex attributes.csv"
tb <- read_data(file)

tb %>%
  arrange(name_fanti)

tb %>%
  tab(c_personid, .desc = TRUE)
