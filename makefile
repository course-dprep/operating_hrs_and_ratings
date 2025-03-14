First rule: ../../gen/output/analysis.pdf ../../gen/output/data_exploration.pdf

../../gen/output/analysis.pdf: analysis.R ../../gen/output/Yelp_clean.csv
	Rscript analysis.R

../../gen/output/Yelp_clean.csv: clean.R ../../gen/temp/Yelp.csv
	Rscript clean.R

../../gen/output/data_exploration.pdf: data_exploration.Rmd ../../gen/temp/Yelp.csv
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('data_exploration.Rmd')""

../../gen/temp/Yelp.csv: merge.R ../../data/Sampled_Data_Business.csv ../../data/Sampled_Data_Review.csv
	Rscript merge.R

../../data/Sampled_Data_Business.csv ../../data/Sampled_Data_Review.csv: download.R 
	Rscript download.R
