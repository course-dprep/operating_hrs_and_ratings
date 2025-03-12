# Installing the latest versions of the packages
install.packages("tidyverse")
install.packages("googledrive")
install.packages("httpuv")

# Loading the packages 
library(tidyverse)
library(googledrive)
library(httpuv)

# Authenticate Google Drive (Users may need to sign in)
drive_auth()

# Define the Google Drive file IDs
file_ids <- c(
  "1p0K_33GrFihdYhqftwtB7NZw6aeg4lmG", # Sampled_Data_Business.csv
  "1LLuuOmiXR4erm3b1wYHfLXhL4pYGddWC"# Sampled_Data_Review.csv
 )

# Define file names for saving
file_names <- c(
  "Sampled_Data_Business.csv",
  "Sampled_Data_Review.csv"
 )

# Loop through the files and download them
for (i in seq_along(file_ids)) {
  drive_download(as_id(file_ids[i]), path = file_names[i], overwrite = TRUE)
}




