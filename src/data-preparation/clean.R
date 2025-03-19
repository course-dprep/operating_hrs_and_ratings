# Installing the necessary packages
install.packages("tidytext")
install.packages("dplyr")
install.packages("textdata")
install.packages("here")
install.packages("tidyverse")
install.packages("stringr")

# Loading the necessary packages 
library(tidytext)
library(dplyr)
library(textdata)
library(here)
library(tidyverse)
library(stringr)

# Loading the Yelp dataset 
Yelp <- read_csv(here("gen", "temp", "Yelp.csv"))

# Filtering for Restaurants that are open
Yelp_clean <- Yelp %>% filter(str_detect(categories, "Restaurants") & is_open == 1 & str_detect(text, "[a-zA-Z]"))
summary(Yelp_clean)
         
#2. Data cleaning & Transformation
Yelp_clean <- Yelp_clean %>% select(business_id, review_count, name, stars.x, state, categories, hours, user_id, text, stars.y)  %>% #Dropping columns 
    rename(Stars_Business = stars.x, Stars_Users = stars.y, Review = text) %>% #Renaming star.x, star.y and text variables
    mutate(Stars_Category = case_when(
    Stars_Business >= 0 & Stars_Business <= 3.5 ~ "low",
    Stars_Business > 3.5 & Stars_Business <= 5 ~ "high",
    TRUE ~ NA_character_
  )) # Add Star Rating category 

# ADD OPENING HOURS VARIABLE 
#First, drop NA's in the column hours - for these businesses there are no opening hours available
colSums(is.na(Yelp_clean))
Yelp_clean <- Yelp_clean %>% drop_na(hours)

#Then we need to check whether restaurants with 0:0-0:0 are opened 24 hours or closed on that day 
inspect_0hours_restaurants <- function(Yelp_clean, hours_col) {
  restaurants_0h <- Yelp_clean %>%
    filter(str_detect({{ hours_col }}, "\\b\\d{1,2}:\\d{1,2}-\\d{1,2}:\\d{1,2}\\b")) %>%  
    filter(str_detect({{ hours_col }}, "'0:0-0:0'")) %>%  #Check for specific cases with 0:0-0:0 in opening hours
    select(name, categories, {{ hours_col }})  #Select the name, categories and specific opening hours for that business 
  
  return(restaurants_0h)
}
#We create a list with the restaurants that contain one or multiple days with these opening hours, to inspect the business and other opening hours of the week 
restaurants_0hours_list <- inspect_0hours_restaurants(Yelp_clean, hours)
restaurants_0hours_list <- restaurants_0hours_list %>%
  distinct(name, .keep_all = TRUE) #Remove all duplicates so the list becomes easier to inspect the list. Each business will be presented once. 

View(restaurants_0hours_list) #For most cases, 0:0-0:0 means they are closed on a specific day. Later on we remove businesses that are opened 0:0-0:0 each day, while we are not sure whether they are closed forever or opened 24H. 

#Create function for counting opening hours 
 extract_opening_hours <- function(Yelp_clean, hours) {
  days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  
  for (day in days) {
    day_col <- paste0(day, "_Hours")  
    
    Yelp_clean <- Yelp_clean %>%
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
  
  return(Yelp_clean)
}
 
Yelp_clean <- extract_opening_hours(Yelp_clean, "hours")
Yelp_clean <- Yelp_clean %>%
  mutate(Open_hours = rowSums(select(., Monday_Open_Hours, Tuesday_Open_Hours, Wednesday_Open_Hours, Thursday_Open_Hours, Friday_Open_Hours, Saturday_Open_Hours, Sunday_Open_Hours), na.rm = TRUE)
  #Sometimes, the opening hours for a certain day misses and this becomes a NA. Means that the restaurant is closed on that day, so don't need to count this for opening hours. 
         )

Yelp_clean <- Yelp_clean %>% 
  select(business_id, review_count, name, state, Stars_Business, categories, hours, user_id, Review, Stars_Users, Stars_Category, Open_hours) %>%
  filter(Open_hours != 0) #Remove business that are not opened, that have 0 opening hours. 

#To inspect the mean Open_Hours
summary(Yelp_clean)

#Create variable that categorizes open_hours in low, middle, high 
Yelp_clean <- Yelp_clean %>% 
  mutate(Hours_category = case_when(
    Open_hours >= 0 & Open_hours <= 55 ~ "low",
    Open_hours > 55 & Open_hours <= 75 ~ "middle",
    Open_hours > 75 ~ "high",
    TRUE ~ NA_character_
  ))

Yelp_clean %>%
  count(Hours_category)

#Drop NA's in the column hours - for restaurants of which no opening hours are not available 
colSums(is.na(Yelp_clean))
Yelp_clean <- Yelp_clean %>% drop_na(hours)

# Sentiment Analysis

# Load the AFINN sentiment lexicon
afinn <- get_sentiments("afinn")

# Assign unique Review_ID
Yelp_clean <- Yelp_clean %>%
  mutate(Review_ID = row_number())

# Tokenize words separately without modifying Yelp_clean
Yelp_sentiment <- Yelp_clean %>%
  select(Review_ID, Review) %>%
  unnest_tokens(word, Review)

# Assign sentiment scores to words
Yelp_sentiment <- Yelp_sentiment %>%
  inner_join(afinn, by = "word") %>%
  group_by(Review_ID) %>%
  summarise(sentiment_score = sum(value, na.rm = TRUE), .groups = "drop")

# **Ensure all reviews are retained by adding missing reviews with sentiment_score = 0**
Yelp_sentiment <- Yelp_clean %>%
  select(Review_ID) %>%
  left_join(Yelp_sentiment, by = "Review_ID") %>%
  mutate(sentiment_score = replace_na(sentiment_score, 0))  # Fill missing scores with 0

# Merge back into Yelp_clean
Yelp_clean <- Yelp_clean %>%
  left_join(Yelp_sentiment, by = "Review_ID") %>%
  select(-Review_ID)  # Remove temporary Review_ID

glimpse(Yelp_clean)

# Save the updated dataset
write_csv(Yelp_clean, here("gen", "output", "Yelp_clean.csv"))
