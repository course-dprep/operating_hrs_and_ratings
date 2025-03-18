# SUBQUESTION 1

# Loading in the packages
library(tidyverse)
library(ggplot2)

# Input: Loading in the cleaned dataset and attaching it.
Yelp_clean <- read_csv("Yelp_clean.csv")
attach(Yelp_clean)

# Transforming into factors for analysis
Yelp_clean$Stars_Category <- factor(Yelp_clean$Stars_Category, levels = c("low", "high"))
Yelp_clean$Hours_category <- as.factor(Yelp_clean$Hours_category)
Yelp_clean$state <- as.factor(Yelp_clean$state)
glimpse(Yelp_clean)



# First Model for answering the first subquestion: How are star ratings affected by the opening hours of restaurants?
Model_Subquestion_1 <- glm(Stars_Category ~ Hours_category + review_count + state, 
                                data = Yelp_clean, family = binomial)
summary(Model_Subquestion_1)  
exp(coef(Model_Subquestion_1))

# Do the covariates improve the model fit? 
reduced_model <- glm(Stars_Category ~ Hours_category,
                     data = Yelp_clean, family = binomial)  # Remove review_count

anova(reduced_model, Model_Subquestion_1, test = "Chisq")

# Plot: Effect of Opening Hours on Probability of High Rating
Yelp_clean$predicted_prob <- predict(Model_Subquestion_1, type = "response")
ggplot(Yelp_clean, aes(x = Hours_category, y = predicted_prob)) +
  geom_boxplot() +
  labs(title = "Effect of Opening Hours on Probability of High Rating",
       x = "Hours Category", 
       y = "Predicted Probability of High Rating")

### Checking the covariates

# PLot: State-wise Differences in High Ratings
ggplot(Yelp_clean, aes(x = state, y = predicted_prob)) +
  geom_boxplot() +
  labs(title = "State-wise Differences in High Ratings",
       x = "State", 
       y = "Predicted Probability of High Rating") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Plot: Effect of Review Count on Probability of High Rating
ggplot(Yelp_clean, aes(x = review_count, y = predicted_prob)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "loess", color = "blue") +
  labs(title = "Effect of Review Count on Probability of High Rating",
       x = "Review Count", 
       y = "Predicted Probability of High Rating")


# Linearity assumption
ggplot(Yelp_clean, aes(x = review_count, y = log(predict(Model_Subquestion_1, type = "response") / (1 - predict(Model_Subquestion_1, type = "response"))))) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "loess", color = "blue") +
  labs(title = "Checking Linearity: Review Count vs. Log-Odds",
       x = "Review Count",
       y = "Log-Odds of High Rating")

# Independence 
table(duplicated(Yelp_clean_aggregated$business_id))  # Count duplicate business IDs
  



library(dplyr)
Yelp_clean_aggregated <- Yelp_clean %>%
  group_by(business_id) %>%
  summarise(
    Stars_Category = first(Stars_Category),  
    Hours_category = first(Hours_category),  
    state = first(state),                    
    review_count = first(review_count)       
  ) %>%
  ungroup()



# SUBQUESTION 2

# Load necessary packages
install.packages("nnet")  # If not installed
library(nnet)

# Convert sentiment_category to a factor with "Neutral" as the reference
Yelp_sentiment$sentiment_category <- factor(Yelp_sentiment$sentiment_category, 
                                            levels = c("Neutral", "Negative", "Positive"))
glimpse(Yelp_sentiment)

# Run multinomial logistic regression with control variables
model_multinom <- multinom(sentiment_category ~ Hours_category + review_count + state + Stars_Business, 
                           data = Yelp_sentiment)

# Display model summary
summary(model_multinom)

exp(coef(model_multinom))


























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