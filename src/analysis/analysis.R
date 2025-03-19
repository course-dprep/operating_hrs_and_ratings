# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(here)
library(lmtest)
library(sandwich)
library(clubSandwich)
library(car)

# Load cleaned dataset
Yelp_clean <- read_csv(here("gen", "output", "Yelp_clean.csv"))

# Converting variables to factors
Yelp_clean$Hours_category <- factor(Yelp_clean$Hours_category, levels = c("low", "middle", "high"))
Yelp_clean$Stars_Category <- factor(Yelp_clean$Stars_Category, levels = c("low", "high")) # Changing the class of Stars_Category into a factor.
Yelp_clean$state <- as.factor(Yelp_clean$state) 
glimpse(Yelp_clean)

# --------------------------------------------------
# Subquestion 1: Effect of Opening Hours on Star Ratings
# --------------------------------------------------

# Aggregate data to ensure independent observations (one per restaurant)
Yelp_clean_aggregated <- Yelp_clean %>%
  group_by(business_id) %>%
  summarise(
    Stars_Category = first(Stars_Category),  
    Hours_category = first(Hours_category),  
    state = first(state),                    
    review_count = first(review_count)       
  ) %>%
  ungroup()

# Fit Logistic Regression Model
logit_model <- glm(Stars_Category ~ Hours_category + review_count + state, 
                   data = Yelp_clean_aggregated, family = binomial)
summary(logit_model)  
exp(coef(logit_model))  # Exponentiate coefficients for interpretation

# Model comparison: checking if covariates improve model fit
logit_reduced_model <- glm(Stars_Category ~ Hours_category,
                           data = Yelp_clean_aggregated, family = binomial)  # Reduced model
anova(logit_reduced_model, logit_model, test = "Chisq")


# ---------------------------
# Assumption Checks
# ---------------------------

# Linearity Check: Logit vs. Review Count
Yelp_clean_aggregated %>%
  mutate(logit = log(fitted(logit_model) / (1 - fitted(logit_model)))) %>%
  ggplot(aes(x = review_count, y = logit)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", color = "blue") +
  labs(title = "Linearity Check: Logit vs. Review Count", 
       x = "Review Count", 
       y = "Logit (Log-Odds)")

# Multicollinearity Check (VIF)
vif(lm(as.numeric(Stars_Category) ~ Hours_category + state + review_count, 
       data = Yelp_clean_aggregated))

# ---------------------------
# Plots
# ---------------------------

# Distribution of Star Ratings by Opening Hours Category
star_rating_by_opening_hours<- ggplot(Yelp_clean_aggregated, aes(x = Hours_category, fill = Stars_Category)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Distribution of Star Ratings by Opening Hours Category",
    x = "Opening Hours Category",
    y = "Count of Restaurants",
    fill = "Star Category"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11)
  )
ggsave(here("gen", "output", "star_rating_by_opening_hours.pdf"), plot = star_rating_by_opening_hours, width = 8, height = 6)

# Predicted Probability of High Rating by Opening Hours Category
predicted_probabilites <-ggplot(Yelp_clean_aggregated, aes(x = Hours_category, y = predict(logit_model, type = "response"), fill = Hours_category)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("low" = "blue", "middle" = "red", "high" ="brown")) + 
  labs(
    title = "Predicted Probability of High Rating by Opening Hours Category",
    x = "Opening Hours Category",
    y = "Predicted Probability of High Rating"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13),
    legend.position = "none"
  )

ggsave(here("gen", "output", "predicted_probabilities.pdf"), plot = predicted_probabilites, width = 8, height = 6)

# --------------------------------------------------
# Subquestion 2: Effect of Opening Hours on Sentiment Score
# --------------------------------------------------

# Fit OLS Model
ols_model <- lm(sentiment_score ~ Hours_category + state + review_count, data = Yelp_clean)

# Model comparison: checking if covariates improve model fit
ols_reduced_model <- lm(sentiment_score ~ Hours_category, data = Yelp_clean)
cat("Adjusted R² for Reduced Model:", summary(ols_reduced_model)$adj.r.squared, "\n")
cat("Adjusted R² for Full Model:", summary(ols_model)$adj.r.squared, "\n")

# ---------------------------
# Assumption Checks
# ---------------------------

# Linearity: Residuals vs. Fitted Values Plot
plot(predict(ols_model), residuals(ols_model),
     xlab = "Predicted Sentiment Score",
     ylab = "Residuals",
     main = "Residuals vs. Fitted Values")
abline(h = 0, col = "blue", lty = 2)  # Add horizontal reference line

# Homoscedasticity Check (Breusch-Pagan Test)
bptest(ols_model)

# Normality Check (QQ Plot)
qqnorm(residuals(ols_model))
qqline(residuals(ols_model), col = "blue")

# Independence Issue: Multiple reviews per restaurant detected
# Addressing with robust clustered standard errors
clustered_se <- vcovCL(ols_model, cluster = Yelp_clean$business_id, type = "HC3")

# Summary with clustered standard errors
coeftest(ols_model, vcov = clustered_se)

# Multicollinearity Check (VIF)
vif(ols_model)

# ---------------------------
# Plots
# ---------------------------

# Residuals vs Fitted values
residuals_vs_fitted <- ggplot(data = Yelp_clean, aes(x = predict(ols_model), y = residuals(ols_model))) +
  geom_point(alpha = 0.5, color = "orange") +  # Scatter points
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  
  labs(
    title = "Residuals vs. Predicted Sentiment Score",
    x = "Predicted Sentiment Score",
    y = "Residuals"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13)
  )
ggsave(here("gen", "output", "residuals_vs_fitted.pdf"), plot = residuals_vs_fitted, width = 8, height = 6)

# Predicted sentiment scores by opening hours category
predicted_sentiment_scores <- ggplot(Yelp_clean, aes(x = Hours_category, y = predict(ols_model), fill = Hours_category)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("low" = "blue", "high" = "red", "middle" = "brown")) +  # Custom colors
  labs(
    title = "Predicted Sentiment Score by Opening Hours Category",
    x = "Opening Hours Category",
    y = "Predicted Sentiment Score"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13),
    legend.position = "none"  # Remove legend since color represents x-axis
  )

ggsave(here("gen", "output", "predicted_sentiment_scores.pdf"), plot = predicted_sentiment_scores, width = 8, height = 6)
