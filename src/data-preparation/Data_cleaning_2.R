#Merge datasets business & review 
Yelp <- merge(Sampled_Data_Business, Sampled_Data_Review, by = "business_id", all = TRUE)

#1. Data Inspection 
View(Yelp)
summary(Yelp)

# Filtering for Restaurants that are open
Yelp_Filtered <- Yelp %>% filter(str_detect(categories, "Restaurants") & is_open == 1 & str_detect(text, "[a-zA-Z]"))
summary(Yelp_Filtered)
         
#2. Data cleaning & Transformation
#Dropping columns 
Yelp_Cleaned <- Yelp_Filtered %>% select(business_id, review_count, name, state, stars.x, state, categories, hours, user_id, text, stars.y)
#Renaming star.x, star.y and text variables 
Yelp_Cleaned <- Yelp_Cleaned %>% rename(Stars_Business = stars.x, Stars_Users = stars.y, Review = text) 

#Adding columns 
#For Star rating category 
Yelp_Transform <- Yelp_Cleaned %>%
  mutate(Stars_Category = case_when(
    Stars_Business >= 0 & Stars_Business <= 3.5 ~ "low",
    Stars_Business > 3.5 & Stars_Business <= 5 ~ "high",
    TRUE ~ NA_character_
  ))
View(Yelp_Transform)

#For Opening hours category 
#Write function 
#Sentiment analysis

#Inspection of NA's
colSums(is.na(Yelp_Transform))
#Drop NA only in crucial columns 
Yelp_Transform <- Yelp_Transform %>% drop_na(hours)

#3. Data exploration and plotting 
#Visualize with ggplot 
