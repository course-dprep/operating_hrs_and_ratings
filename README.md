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

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team 2 members: Tarn van Eijk, Vincent Riemslag, Isa Romeijn, Eline Sprenger, Isabel van Westeneng
