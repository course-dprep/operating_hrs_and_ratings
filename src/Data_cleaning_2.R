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

#For Opening hours category 
extract_opening_hours <- function(Yelp_Transform, hours) {
  days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  
  for (day in days) {
    day_col <- paste0(day, "_Hours")  # Kolomnaam bv. "Monday_Hours"
    
    Yelp_Transform <- Yelp_Transform %>%
      mutate(
        !!day_col := str_extract(!!sym(hours), paste0("'", day, "':\\s*'\\d{1,2}:\\d{1,2}-\\d{1,2}:\\d{1,2}'")),
        !!day_col := str_remove_all(!!sym(day_col), paste0("'", day, "':\\s*'")),
        !!day_col := str_remove_all(!!sym(day_col), "'")
      ) %>%
      separate(!!sym(day_col), into = c(paste0(day, "_Start"), paste0(day, "_End")), sep = "-", remove = FALSE) %>%
      mutate(
        !!paste0(day, "_Start") := as.numeric(str_extract(!!sym(paste0(day, "_Start")), "^\\d{1,2}")),
        !!paste0(day, "_End") := as.numeric(str_extract(!!sym(paste0(day, "_End")), "^\\d{1,2}")),
        !!paste0(day, "_Open_Hours") := ifelse(
          !!sym(paste0(day, "_End")) < !!sym(paste0(day, "_Start")),
          !!sym(paste0(day, "_End")) + 24 - !!sym(paste0(day, "_Start")),
          !!sym(paste0(day, "_End")) - !!sym(paste0(day, "_Start"))
        )
      )
  }
  
  return(Yelp_Transform)
}

Yelp_Transform <- extract_opening_hours(Yelp_Transform, "hours")
Yelp_Transform <- Yelp_Transform %>%
  mutate(Open_hours = rowSums(select(., Monday_Open_Hours, Tuesday_Open_Hours, Wednesday_Open_Hours, Thursday_Open_Hours, Friday_Open_Hours, Saturday_Open_Hours, Sunday_Open_Hours), na.rm = TRUE)
  )

Yelp_Transform <- Yelp_Transform %>% select(business_id, review_count, name, state, Stars_Business, categories, hours, user_id, Review, Stars_Users, Stars_Category, Monday_Open_Hours, Tuesday_Open_Hours, Wednesday_Open_Hours, Thursday_Open_Hours, Friday_Open_Hours, Saturday_Open_Hours, Sunday_Open_Hours, Open_hours)

#To inspect the mean Open_Hours
summary(Yelp_Transform)

#Create variable that categorizes open_hours in low, middle, high 
Yelp_Transform <- Yelp_Transform %>% 
  mutate(Hours_category = case_when(
    Open_hours >= 0 & Open_hours <= 55 ~ "low",
    Open_hours > 55 & Open_hours <= 75 ~ "middle",
    Open_hours > 75 ~ "high",
    TRUE ~ NA_character_
  ))

Yelp_Transform %>%
  count(Hours_category)

#Sentiment analysis

#Inspection of NA's
colSums(is.na(Yelp_Transform))
#Drop NA only in crucial columns 
Yelp_Transform <- Yelp_Transform %>% drop_na(hours)

#3. Data exploration and plotting 
#Visualize with ggplot 
library(ggplot2)
Yelp_Plotting <- Yelp_Transform %>% 
  ggplot(aes(x = Stars_Category)) +
  geom_bar(fill = "blue") +
  labs(title = "Count of Star Categories",
       x = "Stars Category",
       y = "Count") 
Yelp_Plotting
