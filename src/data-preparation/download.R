options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Installing the latest versions of the packages
install.packages("tidyverse")
install.packages("googledrive")
install.packages("httpuv")
install.packages("here")

# Loading the packages 
library(tidyverse)
library(googledrive)
library(httpuv)
library(here)

# De activating authentication for make file
drive_deauth()

# Define the Google Drive file IDs
file_ids <- c(
  "1p0K_33GrFihdYhqftwtB7NZw6aeg4lmG", # Sampled_Data_Business.csv
  "1LLuuOmiXR4erm3b1wYHfLXhL4pYGddWC"# Sampled_Data_Review.csv
 )

# Define file names for saving
file_names <- c(
  here("data", "Sampled_Data_Business.csv"),
  here("data", "Sampled_Data_Review.csv")
)

# Loop through the files and download them
for (i in seq_along(file_ids)) {
  drive_download(as_id(file_ids[i]), path = file_names[i], overwrite = TRUE)
}

