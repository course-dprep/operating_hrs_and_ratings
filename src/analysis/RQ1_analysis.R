options(repos = c(CRAN = "https://cloud.r-project.org/"))

install.packages("lmtest")
install.packages("car")
install.packages("gridExtra")

# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(here)
library(lmtest)
library(car)
library(gridExtra)

# --------------------------------------------------
# Subquestion 1: Effect of Opening Hours on Star Ratings
# --------------------------------------------------
# Load aggregated dataset
Yelp_clean_aggregated <- read_csv(here("gen", "output", "Yelp_clean_aggregated.csv"))

# Converting variables to factors
Yelp_clean_aggregated$Hours_category <- factor(Yelp_clean_aggregated$Hours_category, levels = c("low", "middle", "high"))
Yelp_clean_aggregated$Stars_Category <- factor(Yelp_clean_aggregated$Stars_Category, levels = c("low", "high")) # Changing the class of Stars_Category into a factor.
Yelp_clean_aggregated$state <- as.factor(Yelp_clean_aggregated$state) 
glimpse(Yelp_clean_aggregated)

# Fit Logistic Regression Model
logit_model <- glm(Stars_Category ~ Hours_category + review_count + state, 
                   data = Yelp_clean_aggregated, family = binomial)
summary(logit_model)  
exp(coef(logit_model))  # Exponentiate coefficients for interpretation


# Model comparison: checking if covariates improve model fit
logit_reduced_model <- glm(Stars_Category ~ Hours_category,
                           data = Yelp_clean_aggregated, family = binomial)  # Reduced model
anova(logit_reduced_model, logit_model, test = "Chisq")

table_RQ1 <- tableGrob(summary(logit_model)$coefficients)
ggsave(here("gen", "output", "table_RQ1.png"), table_RQ1, width = 10, height = 6, dpi = 300)

# ---------------------------
# Assumption Checks
# ---------------------------

# Linearity Check: Logit vs. Review Count
Logit_reviewcount <- Yelp_clean_aggregated %>%
  mutate(logit = log(fitted(logit_model) / (1 - fitted(logit_model)))) %>%
  ggplot(aes(x = review_count, y = logit)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", color = "blue") +
  labs(title = "Linearity Check: Logit vs. Review Count", 
       x = "Review Count", 
       y = "Logit (Log-Odds)")

ggsave(here("gen", "output", "Logit_reviewcount.png"), plot = Logit_reviewcount, width = 8, height = 6)

# Multicollinearity Check (VIF)
VIF_RQ1 <- vif(lm(as.numeric(Stars_Category) ~ Hours_category + state + review_count, 
       data = Yelp_clean_aggregated))

VIF_table_RQ1<- tableGrob(VIF_RQ1)
ggsave(here("gen", "output", "VIF_table_RQ1.png"), VIF_table_RQ1, width = 6, height = 2, dpi = 300)

# ---------------------------
# Additional Plots
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
ggsave(here("gen", "output", "star_rating_by_opening_hours.png"), plot = star_rating_by_opening_hours, width = 8, height = 6)

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

ggsave(here("gen", "output", "predicted_probabilities.png"), plot = predicted_probabilites, width = 8, height = 6)
