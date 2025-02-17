# Timing Matters

## Motivation
While there is much research on the impact of opening hours on customer numbers or business, the impact of opening hours on online customer reviews is less well researched. This adds a new perspective to the existing consumer research. Unfavourable opening hours can affect overall customer satisfaction, especially if customers have not considered closing times.

Customer satisfaction is often measured in terms of product quality, customer service and price. In today's digital world, where everything can be accessed quickly and anywhere by mobile phone, the accessibility and availability of a restaurant is becoming increasingly important in addition to these constant variables. Customers now expect flexibility. With quantitative data on reviews combined with sentiment analysis of the textual review, it is possible to determine if a change in the number of hours the restaurant is open can lead to a decrease in reviews. 

## Research Question
*How are customer reviews affected by the opening hours of restaurants in the United States? *

### Sub-Questions
1. How are star ratings affected by the opening hours of restaurants? 
2. How is the sentiment of customer reviews affected by the opening hours of restaurants?

## Background
This quantitative research will take a look at the effect of opening hours of restaurants on customer reviews. Restaurants from all over the world can benefit from this study through better understanding of factors that influence customer reviews. In many cases new customers rely on the reviews of other customers for selecting restaurants, where highly praising reviews increase conversion rates and negative reviews deter purchases. The star rating of reviews will be logistic regressed on the opening hours of restaurants to find the answer to sub question 1. Using sentiment analysis on the written customer reviews will provide a idea of what is being discussed and the effect of opening hours on this sentiment can be analysed with an ordinal logistic regression model.

## Method
For sub question 1, our dependent variable is star rating. This will be a categorical variable as we will them group into high star rating (4-5 stars) and low star rating (1-3 stars). The independent variable is opening hours, which is also categorical. The total amount of hours a restaurant is opened, will be counted. Two groups will be separated: high / low amount of opened hours. Because both the dependent variable star rating and the independent variable opening hours are categorical a binary logistic model will return the relationship and give predictability scores. For sub question 2, our dependent variable is the sentiment of customer reviews. This will be a categorical variable with 3 groups which have a natural order (negative \< neutral \< positive). The independent variable is opening hours, similar to question 1. An ordinal logistic regression model will be used for sub question 2. Customer reviews are categorized into 3 ordinal levels and opening hours into two levels. The result of this model will give the probabilities of sentiment levels based on the opening hours of a restaurant.

## Data

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Deployment Information
The project can easily be followed along by this README.md file. In here an overview of our research is presented and the questions which will be answered. The code in this file can be ran in any Python supported software such as Jupyter notebook or Google colab. Following this document from top to bottom all necessary packages and data sets will be loaded. This document contains the code to create the shown graphs and excecute the statistical analysis. 

## Repository Overview 

**Include a tree diagram that illustrates the repository structure*

## Dependencies 

*Firstly, several packages are loaded into our Rstudio. 

```{r}
library(tidyverse)
library(dplyr)
library(here)
library(stringr)
```
*

## Running Instructions 

*Four our research, we only need the business dataset and review dataset of Yelp, which we downloaded from https://business.yelp.com/data/resources/open-dataset/  

```{r}
Data_Bus <- read_csv(here("data", "yelp_academic_dataset_business.csv"))
Data_Review <- read_csv(here("data","yelp_academic_dataset_review.csv"))
```

As both datasets contained a business_id variable, we merged them together by business_id.

```{r}
Data_Merged <- merge(Data_Bus, Data_Review, by = "business_id", all = TRUE)
```

We filtered the dataset on specific variables and conditions, to  make sure our hardware can process this large dataset. 

We only look at categories which included "Restaurants", which are not permanently closed. Secondly, based on the median of review_count we only included businesses with more then, or equal to 135 reviews. Additionally, we only selected the variables needed, which is still subject to some changes regarding the implementation of potential control variables. 

```{r}
# Looking for a good minimal threshold of amount of reviews a business has. 
summary(Data_Merged$review_count)

# Checking the amount of reviews per state to check which state is suitable. 
Data_Merged %>% count(state)

# Filtering the data of the merged data set
Data_Merged_Filtered <- Data_Merged %>% 
  filter(str_detect(categories, "Restaurants"),
         is_open == 1,
         review_count >= 135,
         state == "IL")%>% 
  select(review_count, name, state, categories, hours, business_id, text, stars.x, stars.y, user_id)
         
  # renaming the star.x, star.y and text variables
Data_Merged_Filtered <- Data_Merged_Filtered %>% 
  rename(Stars_Business = stars.x, Stars_Users = stars.y, Review = text) 

# Getting rid of the NA's
Data_Merged_Filtered <- na.omit(Data_Merged_Filtered)
```

As we conduct a sentiment analysis, we need to make sure reviews have a sufficient length to be suitable for analysis. Therefore we filtered the amount of words to be greater then 10). 

```{r}
 # Reviews >10 words. 
Data_Merged_Final<- Data_Merged_Filtered %>% filter((str_count(Review, " ") + 1) > 10)
```
*

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team < x > members: < insert member details>
