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
  "1GmZeV7raNZtKLdks1SBMzUgkV1FKBHOK", # Sampled_Data_Business.csv
  "1MxG9RhUvjVSn00vYoeNEJE_cbS8wY6sh",  # Sampled_Data_Review.csv
  "1VuFVuuL8wQOQkypmrmckbSNjQGxe1AlS",  # Sampled_Data_Checkin.csv
  "1S2sY2n9QqXpM-X718KAiZqR4fYYlqWJb",  # Sampled_Data_Tip.csv
  "1AduVWGiFWxQf9mpicRTeHmN35Y1CB9oh"   # Data_User.csv
)

# Define file names for saving
file_names <- c(
  "Sampled_Data_Business.csv",
  "Sampled_Data_Review.csv",
  "Sampled_Data_Checkin.csv",
  "Sampled_Data_Tip.csv",
  "Data_User.csv"
)

# Loop through the files and download them
for (i in seq_along(file_ids)) {
  drive_download(as_id(file_ids[i]), path = file_names[i], overwrite = TRUE)
}

# Load the downloaded files into R
Sampled_Data_Business <- read_csv("Sampled_Data_Business.csv")
Sampled_Data_Review <- read_csv("Sampled_Data_Review.csv")
Sampled_Data_Checkin <- read_csv("Sampled_Data_Checkin.csv")
Sampled_Data_Tip <- read_csv("Sampled_Data_Tip.csv")
Data_User <- read_csv("Data_User.csv")

