# Importing packages
library(tidyverse)
library(here)
library(dplyr)

# Loading in the data sets
Data_Reviews <- read_csv(here("yelp_academic_dataset_review.csv"))
Data_Business <- read_csv(here("yelp_academic_dataset_business.csv"))
Data_Checking <- read_csv(here("yelp_academic_dataset_checkin.csv"))
Data_Tip <- read_csv(here("yelp_academic_dataset_tip.csv"))
Data_User <- read_csv(here("yelp_academic_dataset_user.csv"))

# Filtering on restaurants
Data_Business_Restaurants <- Data_Business %>%
  filter(str_detect(categories, "Restaurants"))

# Sample Business
Sampled_Business <- Data_Business_Restaurants %>% 
  sample_n(5000)

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
write_csv(Sampled_Business, "Sampled_Data_Business.csv")
write_csv(Sampled_Review, "Sampled_Data_Review.csv")
write_csv(Sampled_Tip, "Sampled_Data_Tip.csv")
write_csv(Sampled_Checking, "Sampled_Data_Checkin.csv")

