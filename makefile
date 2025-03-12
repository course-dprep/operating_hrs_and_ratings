First rule: analysis.pdf

analysis.pdf: analysis.R Yelp_clean.csv
	R --vanilla < analysis.R

Yelp_clean.csv: clean.R Yelp.csv
	R --vanilla < clean.R

data_exploration.pdf: data_exploration.Rmd Yelp.csv
	R --vanilla < data_exploration.Rmd

Yelp.csv: merge.R Sampled_Data_Business.csv Sampled_Data_Review.csv
	R --vanilla < merge.R

Sampled_Data_Business.csv Sampled_Data_Review.csv: download.R 
	R --vanilla < download.Rhis makefile will be used to automate the
# different steps in your project.