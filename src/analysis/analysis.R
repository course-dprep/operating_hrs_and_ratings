# In this directory, you will keep all source code related to your analysis.

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