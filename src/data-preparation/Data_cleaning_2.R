# Filtering for Restaurants that are open
Data_Merged_Filtered <- Data_Merged %>% 
  filter(str_detect(categories, "Restaurants"),
         is_open == 1 %>% 
           select(review_count, name, state, categories, hours, business_id, text, stars.x, stars.y, user_id))
         
# renaming the star.x, star.y and text variables
Data_Merged_Filtered <- Data_Merged_Filtered %>% 
  rename(Stars_Business = stars.x, Stars_Users = stars.y, Review = text) 
         
#Inspection of NA's
# Count number of NAs in each column and row 
colSums(is.na(Data_Merged_Filtered))
rowSums(is.na(Data_Merged_Filtered))

#Drop NA only in crucial columns 
Data_Merged_Filtered <- Data_Merged_Filtered %>% drop_na(categories, hours, business_id, text, stars.x, stars.y)

# Getting rid of the NA's
Data_Merged_Filtered <- na.omit(Data_Merged_Filtered)