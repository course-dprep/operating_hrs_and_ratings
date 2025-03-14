First rule: analysis.pdf data_exploration.pdf

analysis.pdf: analysis.R Yelp_clean.csv
	Rscript analysis.R

Yelp_clean.csv: clean.R Yelp.csv
	Rscript clean.R

data_exploration.pdf: data_exploration.Rmd Yelp.csv
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render("data_exploration.Rmd")""

Yelp.csv: merge.R Sampled_Data_Business.csv Sampled_Data_Review.csv
	Rscript merge.R

Sampled_Data_Business.csv Sampled_Data_Review.csv: download.R 
	Rscript download.R