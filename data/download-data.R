# Installing the latest versions of the packages
install.packages("tidyverse")
install.packages("googledrive")
install.packages("httpuv")

# Loading the packages 
library(tidyverse)
library(googledrive)
library(httpuv)

# Google Drive ID 
drive_id <-"1kiigtjqbJpwRVyQSNCWgDmpqVVL2Jcyx"

# Downloading the files
drive_download("Sampled_Data_Business.csv", overwrite = TRUE)
drive_download("Sampled_Data_Review.csv", overwrite = TRUE)
drive_download("Sampled_Data_Checkin.csv", overwrite = TRUE)
drive_download("Sampled_Data_Tip.csv", overwrite = TRUE)
drive_download("Data_User.csv", overwrite = TRUE)

# Loading the files in as csv
Sampled_Data_Business <- read_csv("Sampled_Data_Business.csv")
Sampled_Data_Review <- read_csv("Sampled_Data_Review.csv")
Sampled_Data_Checkin <- read_csv("Sampled_Data_Checkin.csv")
Sampled_Data_Tip <- read_csv("Sampled_Data_Tip.csv")
Data_User <- read_csv("Data_User.csv")



