options(repos = c(CRAN = "https://cloud.r-project.org/"))

#Install packages
install.packages("tidyverse")
install.packages("here")

# Loading packages 
library(tidyverse)
library(here)

# Loading in the dowloaded csv files
Sampled_Data_Business <- read_csv(here("data", "Sampled_Data_Business.csv"))
Sampled_Data_Review <- read_csv(here("data", "Sampled_Data_Review.csv"))

# Merge datasets business & review 
Yelp <- merge(Sampled_Data_Business, Sampled_Data_Review, by = "business_id", all = TRUE)

# Write a csv file for the merged dataset
write_csv(Yelp, here("gen", "temp", "Yelp.csv"))