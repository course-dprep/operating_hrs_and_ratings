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
  "1LLuuOmiXR4erm3b1wYHfLXhL4pYGddWC",  # Sampled_Data_Review.csv
  "1XzR2t4k3qRR7jM9sc6UEOiuK_1RRKU_R",  # Sampled_Data_Checkin.csv
  "1HKb9h3_lSsv7jhetahVPCajHrNJzKvQ5",  # Sampled_Data_Tip.csv
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

