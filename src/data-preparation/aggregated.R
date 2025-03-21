options(repos = c(CRAN = "https://cloud.r-project.org/"))

library(tidyverse)
library(here)

# Load cleaned dataset
Yelp_clean <- read_csv(here("gen", "output", "Yelp_clean.csv"))

# Converting variables to factors
Yelp_clean$Hours_category <- factor(Yelp_clean$Hours_category, levels = c("low", "middle", "high"))
Yelp_clean$Stars_Category <- factor(Yelp_clean$Stars_Category, levels = c("low", "high")) # Changing the class of Stars_Category into a factor.
Yelp_clean$state <- as.factor(Yelp_clean$state) 
glimpse(Yelp_clean)

# Aggregate data to ensure independent observations for RQ1 (one per restaurant)
Yelp_clean_aggregated <- Yelp_clean %>%
  group_by(business_id) %>%
  summarise(
    Stars_Category = first(Stars_Category),  
    Hours_category = first(Hours_category),  
    state = first(state),                    
    review_count = first(review_count)       
  ) %>%
  ungroup()

write_csv(Yelp_clean_aggregated, here("gen", "output", "Yelp_clean_aggregated.csv"))