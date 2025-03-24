# Timing Matters

## Motivation

While there is much research on the impact of opening hours on customer numbers or business, the impact of opening hours on online customer reviews is less well researched. This adds a new perspective to the existing consumer research. Unfavourable opening hours can affect overall customer satisfaction, especially if customers have not considered closing times.

Customer satisfaction is often measured in terms of product quality, customer service and price. In today's digital world, where everything can be accessed quickly and anywhere by mobile phone, the accessibility and availability of a restaurant is becoming increasingly important in addition to these constant variables. Customers now expect flexibility. With quantitative data on reviews combined with sentiment analysis of the textual review, it is possible to determine if a change in the number of hours the restaurant is open can lead to a decrease in reviews.

## Research Question

*How are customer reviews affected by the opening hours of restaurants in the United States?*

### Sub-Questions

1.  How are star ratings affected by the opening hours of restaurants?
2.  How is the sentiment of customer reviews affected by the opening hours of restaurants?

## Background

Online reviews are becoming increasingly important in today's digital age, where word of mouth is no longer limited to knowledge circles. In many cases, new customers rely on other customers' reviews to choose restaurants. Highly positive reviews increase conversion rates, while negative reviews discourage purchases. Restaurants should therefore be aware of how online reviews reflect their performance. Customers specifically leave reviews based on multiple dimensions of their experience, including star ratings and sentiment through text. A restaurant's opening hours, which can vary widely depending on location and type of service, among other factors, can influence the reviews and sentiments expressed by customers. This quantitative study will look at how restaurant hours affect the reviews given by customers.

## Method

### Sub-question 1: How are star ratings affected by the opening hours of restaurants?

We used a logistic regression model to examine the relationship between opening hours (`Hours_category`) and star ratings (`Stars_Category`, classified as high: 4–5 stars, or low: 1–3 stars). We included two control variables:

-   `review_count`: to account for customer engagement
-   `state`: to control for regional differences

We checked model assumptions (linearity, multicollinearity, independence) and compared a full model (with covariates) against a reduced model (only hours) using a likelihood ratio test. To ensure independence of observations, we used an aggregated dataset with one row per restaurant.

### Sub-question 2: How is the sentiment of customer reviews affected by the opening hours of restaurants?

We applied an OLS regression model to predict the `sentiment_score` of customer reviews based on `Hours_category`, again controlling for `review_count` and `state`. Sentiment scores were calculated by summing sentiment values of words using the AFINN lexicon.

Model assumptions (linearity, independence, homoscedasticity, normality, multicollinearity) were checked or discussed. Since multiple reviews per restaurant were used, we clustered standard errors at the restaurant level. Model performance was evaluated using adjusted R².

### Variable table

| Variable Name   | Description                                | Type                 | Operationalization                            | Possible Values             |
|---------------|---------------|---------------|---------------|---------------|
| Star_Category   | Average star rating for the restaurant     | Categorical (Binary) | Grouped into High (4-5) and Low (1-3)         | High, Low                   |
| sentiment_score | Sentiment score of customer reviews        | Continuous           | Overall emotional tone of a review            | Numbers from -64 to 136     |
| Hours_category  | Total hours restaurant is open             | Ordinal              | 0-55 = low, 56-75 = middle, 76+ = high        | Low, middle, high           |
| review_count    | Total number of reviews for a restaurant   | Continuous           | Count of all reviews received by a restaurant | Numbers from 5 to 4,876     |
| state           | U.S. state where the restaurant is located | Categorical          | Two-letter state abbreviation                 | Any U.S. state abbreviation |

## Preview of Findings

Our analysis shows a consistent and significant pattern: restaurants with longer opening hours tend to receive worse customer reviews — both in terms of star ratings (quantitative) and the sentiment expressed (qualitative) in written reviews.

Using logistic and linear regression models, we discovered that restaurants with middle or high opening hours are significantly less likely to receive high star ratings (4–5 stars), with up to 85% lower odds compared to those with low opening hours. Similarly, customer sentiment scores decrease as opening hours increase, suggesting that longer hours are associated with more negative review language.

These findings were robust even after controlling for the number of reviews and the state in which the restaurant was located.

These results highlight that longer operating hours may come at a reputational cost. Restaurant managers and owners can use these insights to find a better balance between availability and perceived service quality.


## Repository Overview

```         
├── data
├── gen
   ├── output
   └── temp
├── reporting
└── src
   ├── analysis
   ├── data-preparation
├── .gitignore
├── README.md
├── makefile
```

## Deployment information

The src folder  contains code for how we did our sampling, to illustrate the criteria used. However, you do not need to file to run the project. 
The sampled datasets are stored via Google Drive, while the non-sampled datasets were too heavy for our computers to download. As this was not a primarly goal of this course, only one group member sampled the datasets and added them to Google Drive. Therefore, the makefile starts with download.R. 


## Dependencies 

- R. [Installation guide](https://tilburgsciencehub.com/building-blocks/configure-your-computer/statistics-and-computation/r/).
- Make. [Installation guide](https://tilburgsciencehub.com/building-blocks/configure-your-computer/automation-and-workflows/make/).
- To knit RMarkdown documents, make sure you have installed Pandoc using the [installation guide](https://pandoc.org/installing.html) on their website.

- For R, install the following packages: 
```
install.packages("tidyverse")
install.packages("googledrive")
install.packages("httpuv")
install.packages("here")
install.packages("tidytext")
install.packages("dplyr")
install.packages("stringr")
install.packages("ggplot2")
install.packages("skimr")
install.packages("lmtest")
install.packages("car")
install.packages("gridExtra")
install.packages("fixest")
install.packages("sandwich")
install.packages("clubSandwich")
```

## Running the code 
To run the entire project, follow the next steps: 

1. Fork this repository

2. Open your command line / terminal and run the following code:
```
git clone https://github.com/course-dprep/operating_hrs_and_ratings.git
```
3. Set your working directory to `operating_hrs_and_ratings` and run the following command:
```
make
```
4. When make has succesfully run all the code, it will generate a PDF in the folder 'reporting'. This document clearly presents the overview of our research, methodology, output tables, data visualisations and the conclusion. Additionally, a html-document will be created that shows the initial exploration of our data. 

## About

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team 4 members: Tarn van Eijk, Vincent Riemslag, Isa Romeijn, & Isabel van Westeneng
