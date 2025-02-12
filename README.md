> **Important:** This is a template repository to help you set up your team project.  
>  
> You are free to modify it based on your needs. For example, if your data is downloaded using *multiple* scripts instead of a single one (as shown in `\data\`), structure the code accordingly. The same applies to all other starter files—adapt or remove them as needed.  
>  
> Feel free to delete this text.


# Title of your Project
*Timing Matters* 

## Motivation

*How are customer reviews affected by the opening hours of restaurants in the United States? *

**Mention your research question**

## Data

1. How are star ratings affected by the opening hours of restaurants? 
2. How is the sentiment of customer reviews affected by the opening hours of restaurants?

## Method

*For sub question 1, our dependent variable is star rating. This will be a categorical variable as we will them group into high star rating (4-5 stars) and low star rating (1-3 stars). The independent variable is opening hours, which is also categorical. The total amount of hours a restaurant is opened, will be counted. Two groups will be separated: high / low amount of opened hours. 

For sub question 2, our dependent variable is the sentiment of customer reviews. This will be a categorical variable with 3 groups which have a natural order (negative < neutral < positive). The independent variable is opening hours, similar to question 1.

Given the research questions, a logistic regression and an ordinal logistic regression model will be used for analyzing the Yelp data set.*

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

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
