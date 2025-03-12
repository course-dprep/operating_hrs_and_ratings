# Loading packages 
library(tidyverse)

# Loading in the dowloaded csv files
Sampled_Data_Business <- read_csv("Sampled_Data_Business.csv")
Sampled_Data_Review <- read_csv("Sampled_Data_Review.csv")

# Merge datasets business & review 
Yelp <- merge(Sampled_Data_Business, Sampled_Data_Review, by = "business_id", all = TRUE)

# Write a csv file for the merged dataset
write_csv(Yelp, "../src/data-preparation/Yelp.csv")

