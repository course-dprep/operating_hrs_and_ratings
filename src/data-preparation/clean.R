# Installing the necessary packages

# Loading the necessary packages 
install.packages("tidytext")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("textdata")

# Loading the Yelp dataset 
Yelp <- read_csv(here("gen", "temp", "Yelp.csv"))

# Filtering for Restaurants that are open
Yelp_clean <- Yelp %>% filter(str_detect(categories, "Restaurants") & is_open == 1 & str_detect(text, "[a-zA-Z]"))
summary(Yelp_clean)
         
#2. Data cleaning & Transformation
Yelp_clean <- Yelp_clean %>% select(business_id, review_count, name, state, stars.x, state, categories, hours, user_id, text, stars.y)  %>% #Dropping columns 
    rename(Stars_Business = stars.x, Stars_Users = stars.y, Review = text) %>% #Renaming star.x, star.y and text variables
    mutate(Stars_Category = case_when(
    Stars_Business >= 0 & Stars_Business <= 3.5 ~ "low",
    Stars_Business > 3.5 & Stars_Business <= 5 ~ "high",
    TRUE ~ NA_character_
  )) # Add Star Rating category 

# Add Opening Hours category
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

Yelp_clean <- Yelp_clean %>% select(business_id, review_count, name, state, Stars_Business, categories, hours, user_id, Review, Stars_Users, Stars_Category, Open_hours)

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

# Sentimental Analysis
afinn <- get_sentiments("afinn")

#verwerk tekst met berekenen sentiment-score
yelp_words <- Yelp_Transform %>%
  select(Review, Stars_Users) %>%  # Behoud de reviewtekst én sterrenbeoordelingen
  mutate(Review_ID = row_number()) %>%  # Voeg een unieke ID toe voor zekerheid
  unnest_tokens(word, Review)  # Splits de tekst in woorden, behoud de andere kolommen

#sentiment-score PER REVIEW
yelp_sentiment <- yelp_words %>%
  inner_join(afinn, by = "word") %>%  
  group_by(Review_ID) %>%  # Groepeer per Review_ID (niet Review!)
  summarise(sentiment_score = sum(value, na.rm = TRUE), .groups = "drop") %>%
  left_join(Yelp_Transform %>% mutate(Review_ID = row_number()) %>% select(Review_ID, Stars_Users), by = "Review_ID")  # Voeg sterren toe

#check 
head(yelp_sentiment)

#categoriseren
yelp_sentiment <- yelp_sentiment %>%
  mutate(sentiment_category = case_when(
    sentiment_score < -1 ~ "Negatief",
    sentiment_score > 1  ~ "Positief",
    TRUE                 ~ "Neutraal"
  ))

#check
table(yelp_sentiment$sentiment_category)

#Drop NA's in the column hours - for restaurants of which no opening hours are not available 
colSums(is.na(Yelp_clean))
Yelp_clean <- Yelp_clean %>% drop_na(hours)

#Write csv file
write_csv(Yelp_clean, here("gen", "output", "Yelp_clean.csv"))











