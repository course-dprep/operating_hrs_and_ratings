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
Online reviews are becoming increasingly important in today's digital age, where word of mouth is no longer limited to knowledge circles. In many cases, new customers rely on other customers' reviews to choose restaurants. Highly positive reviews increase conversion rates, while negative reviews discourage purchases. Restaurants should therefore be aware of how online reviews reflect their performance. Customers specifically leave reviews based on multiple dimensions of their experience, including star ratings and sentiment through text. A restaurant's opening hours, which can vary widely depending on location and type of service, among other factors, can influence the reviews and sentiments expressed by customers. This quantitative study will look at how restaurant hours affect the reviews given by customers.

## Method
For sub question 1, our dependent variable is business star rating, which is the average star rating of all customers reviews for one business. This will be a categorical variable as we will them group into high star rating (4-5 stars) and low star rating (1-3 stars). The independent variable is opening hours, which is also categorical as it is separated into three groups: high, middle and low amount of hours opened. The variabel 'Open_hours' that is the total amount of hours opened a week, will be created by counting the opened hours of a restaurant for each day. Because both the dependent variable star rating and the independent variable opening hours are categorical a logistic regression model will return the relationship and give predictability scores. 

For sub question 2, our dependent variable is the sentiment of customer reviews. This will be a continuous variable with a sentiment score, which represents the overall emotional tone of a review by summing the individual sentiment values of words. The more positive the sentiment score, the more positive the sentiment in a review, and the other way around. The independent variable is opening hours with three groups (low, middle, high), similar to question 1. An ordinal logistic regression model will be used for sub question 2. The result of this model will give the probabilities of sentiment levels based on the opening hours of a restaurant.

### Variable table
| Variable Name  | Description                                   | Type        | Operationalization                                      | Possible Values               |
|---------------|-------------------------------------------|------------|--------------------------------------------------|------------------------------|
| Star Rating   | Average star rating for the restaurant       | Categorical (Binary) | Grouped into High (4-5) and Low (1-3)         | High, Low        |
| Sentiment     | Sentiment score of customer reviews           | Continuous     | Overall emotional tone of a review  | Numbers from -... to ...  |
| Opening Hours | Total hours restaurant is open          | Ordinal | 0-55 = low, 56-75 = middle, 76+ = high      | Low, middle, high                   |


## Data

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Deployment Information
This project is easy to follow using an R Markdown document in the src folder. This document clearly presents the overview of our research, the research questions and the methodology. All the necessary packages are loaded and the datasets can be found in the data folder. The data is stored via Google Drive and can be opened using RStudio. The code to create the necessary visualisations and statistical analysis is also included.

To run the entire project, type "make" in the command prompt and run. Make has to be installed in order for it to work. 

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

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team 4 members: Tarn van Eijk, Vincent Riemslag, Isa Romeijn, & Isabel van Westeneng
