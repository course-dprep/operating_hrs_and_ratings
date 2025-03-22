options(repos = c(CRAN = "https://cloud.r-project.org/"))

install.packages("tidyverse")
install.packages("ggplot2")
install.packages("here")
install.packages("lmtest")
install.packages("sandwich")
install.packages("clubSandwich")
install.packages("car")
install.packages("gridExtra")

# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(here)
library(lmtest)
library(sandwich)
library(clubSandwich)
library(car)
library(gridExtra)

# --------------------------------------------------
# Subquestion 2: Effect of Opening Hours on Sentiment Score
# --------------------------------------------------

# Load cleaned dataset
Yelp_clean <- read_csv(here("gen", "output", "Yelp_clean.csv"))

# Converting variables to factors
Yelp_clean$Hours_category <- factor(Yelp_clean$Hours_category, levels = c("low", "middle", "high"))
Yelp_clean$Stars_Category <- factor(Yelp_clean$Stars_Category, levels = c("low", "high")) # Changing the class of Stars_Category into a factor.
Yelp_clean$state <- as.factor(Yelp_clean$state) 
glimpse(Yelp_clean)

# Fit OLS Model
ols_model <- lm(sentiment_score ~ Hours_category + state + review_count, data = Yelp_clean)

# Model comparison: checking if covariates improve model fit
ols_reduced_model <- lm(sentiment_score ~ Hours_category, data = Yelp_clean)
cat("Adjusted R² for Reduced Model:", summary(ols_reduced_model)$adj.r.squared, "\n")
cat("Adjusted R² for Full Model:", summary(ols_model)$adj.r.squared, "\n")

# ---------------------------
# Assumption Checks
# ---------------------------

# Linearity Check
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

ggsave(here("gen", "output", "residuals_vs_fitted.png"), plot = residuals_vs_fitted, width = 8, height = 6)

# Homoscedasticity Check (Breusch-Pagan Test)
bptest(ols_model)

# Normality Check (QQ Plot)
qqnorm(residuals(ols_model))
qqline(residuals(ols_model), col = "blue")
png(here("gen", "output", "QQ_Plot.png")); qqnorm(residuals(ols_model)); qqline(residuals(ols_model), col = "blue"); dev.off()

# Independence Issue: Multiple reviews per restaurant detected
# Addressing with robust clustered standard errors
clustered_se <- vcovCL(ols_model, cluster = Yelp_clean$business_id, type = "HC3")

# Summary with clustered standard errors
table_RQ2 <- tableGrob(coeftest(ols_model, vcov = clustered_se))
ggsave(here("gen", "output", "table_RQ2.png"), table_RQ2, width = 10, height = 6, dpi = 300)

# Multicollinearity Check (VIF)
VIF_RQ2 <- tableGrob(vif(ols_model))
ggsave(here("gen", "output", "VIF_RQ2.png"), VIF_RQ2, width = 6, height = 2, dpi = 300)

# ---------------------------
# Additional Plots
# ---------------------------

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

ggsave(here("gen", "output", "predicted_sentiment_scores.png"), plot = predicted_sentiment_scores, width = 8, height = 6)
