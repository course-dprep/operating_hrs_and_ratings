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

Yelp_Transform <- Yelp_Transform %>% select(business_id, review_count, name, state, Stars_Business, categories, hours, user_id, Review, Stars_Users, Stars_Category, Open_hours)

#Inspection of NA's
colSums(is.na(Yelp_Transform))
Yelp_Transform[is.na(Yelp_Transform$hours), ]
#Drop NA's in the column hours - for those restaurants opening hours are not available 
Yelp_Transform <- Yelp_Transform %>% drop_na(hours)
colSums(is.na(Yelp_Transform))

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

#sentiment analyse
#install packages
install.packages("tidytext")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("textdata")

#load package
library(tidytext)
library(dplyr)
library(ggplot2)
library(textdata)
library(tidyr)

#sentimentanalyse met AFINN
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

#visualiseer sentiment
Sentiment_scatterplot <- ggplot(yelp_sentiment, aes(x = sentiment_category, fill = sentiment_category)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Sentimentanalyse van Yelp-reviews",
       x = "Sentiment",
       y = "Aantal reviews") +
  scale_fill_manual(values = c("Negatief" = "red", "Neutraal" = "gray", "Positief" = "green"))

#visualiseer sentiment vs star rating
Realtionship_starrating_sentiment <- ggplot(yelp_sentiment, aes(x = Stars_Users, y = sentiment_score)) +
  geom_point(alpha = 0.5, color = "blue") +
  theme_minimal() +
  labs(title = "Relation between Starrating and Sentiment Score",
       x = "Star Rating ",
       y = "Sentiment Score")

#correlatie controleren
cor(yelp_sentiment$sentiment_score, yelp_sentiment$Stars_Users, use = "complete.obs") #0.4

#boxplot die laat zien hoe breed de sentimentscores binnen de starrating > veel overlap verklaart zwakke correlatie
ggplot(yelp_sentiment, aes(x = factor(Stars_Users), y = sentiment_score)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Rating of Sentiment by Star Rating",
       x = "Star Rating",
       y = "Sentiment Score")

#ander sentiment NCR (8 emoties; rijkere sentiment data)
yelp_sentiment_nrc <- yelp_words %>%
  inner_join(get_sentiments("nrc"), by = "word", relationship = "many-to-many") %>%  
  count(Review_ID, sentiment) %>%  
  spread(sentiment, n, fill = 0)

#verdeling emoties per star rating; welke emoties het meest voorkomen per star rating
Star_Rating_emotions <- yelp_sentiment_nrc %>%
  left_join(Yelp_Transform %>% mutate(Review_ID = row_number()) %>% select(Review_ID, Stars_Users), by = "Review_ID") %>%
  gather(key = "emotie", value = "aantal", -Review_ID, -Stars_Users) %>%
  ggplot(aes(x = factor(Stars_Users), y = aantal, fill = emotie)) +
  geom_bar(stat = "identity", position = "stack") +
  theme_minimal() +
  labs(title = "number of emotion words per star rating",
       x = "Star Rating",
       y = "Number of emotiion words")

#correlatie emoties en sterren
install.packages("corrr")
library(corrr)  

# Voeg sterrenbeoordeling toe aan het sentiment dataframe
yelp_sentiment_nrc <- yelp_sentiment_nrc %>%
  left_join(Yelp_Transform %>% mutate(Review_ID = row_number()) %>% select(Review_ID, Stars_Users), by = "Review_ID")

# correlatie hoge star rating en emoties
cor_matrix <- yelp_sentiment_nrc %>%
  select(-Review_ID) %>%  
  correlate()  

cor_matrix %>% focus(Stars_Users) %>% arrange(desc(Stars_Users))

library(broom)

#logistische regression
yelp_sentiment_nrc <- yelp_sentiment_nrc %>%
  mutate(stars_binary = ifelse(Stars_Users >= 4, 1, 0))  # 1 = Hoge score (4-5), 0 = Lage score (1-3)

logit_model <- glm(stars_binary ~ ., data = yelp_sentiment_nrc %>% select(-Review_ID, -Stars_Users), 
                   family = binomial)

summary(logit_model)

# dataframe van de regressieresultaten
logit_results <- broom::tidy(logit_model)

# Filter alleen de significante emoties (p < 0.05)
significant_logit <- logit_results %>% filter(p.value < 0.05)

# Plot de significante emoties
ggplot(significant_logit, aes(x = reorder(term, estimate), y = estimate, fill = estimate > 0)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Significant emotions that influence star ratings (logistic model)",
       x = "Emotion",
       y = "Effect on chance of high rating") +
  scale_fill_manual(values = c("red", "blue"), name = "Effect",
                    labels = c("Negative", "Positive"))
