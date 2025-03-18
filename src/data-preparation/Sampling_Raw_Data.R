# IMPORTANT, These code snippets only work if you have downloaded the raw data locally on your hardware!

# Importing packages
library(tidyverse)
library(here)
library(dplyr)

# Loading in the data sets
Data_Reviews <- read_csv(here("yelp_academic_dataset_review.csv"))
Data_Business <- read_csv(here("yelp_academic_dataset_business.csv"))

# Sample Business
Sampled_Business <- Data_Business %>% 
  sample_n(10000)

# Sample Reviews
Sampled_Review <- Data_Reviews %>% 
  semi_join(Sampled_Business, by = "business_id")
  
  # Checking if it worked correctly
Sampled_Review %>% count(business_id)

# Sample Tip 
Sampled_Tip <- Data_Tip %>% 
  semi_join(Sampled_Business, by = "business_id")

  # Checking if it worked correctly 
Sampled_Tip %>% count(business_id)

# Sample Checking
Sampled_Checking <- Data_Checking %>% 
  semi_join(Sampled_Business, by = "business_id")

# Writing the csv's
write_csv(Sampled_Business, here("data", "Sampled_Data_Business.csv")
write_csv(Sampled_Review, here("data","Sampled_Data_Review.csv")