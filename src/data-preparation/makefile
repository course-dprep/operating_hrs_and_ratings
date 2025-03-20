TEMP = ../../gen/temp
OUTPUT = ../../gen/output
DATA = ../../data

First rule: $(OUTPUT)/Yelp_clean_aggregated.csv $(OUTPUT)/data_exploration.pdf 

$(OUTPUT)/Yelp_clean_aggregated.csv: aggregated.R $(OUTPUT)/Yelp_clean.csv
	Rscript aggregated.R

$(OUTPUT)/Yelp_clean.csv: clean.R $(TEMP)/Yelp.csv
	Rscript clean.R

$(OUTPUT)/data_exploration.pdf: data_exploration.Rmd $(TEMP)/Yelp.csv
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('data_exploration.Rmd')""

$(TEMP)/Yelp.csv: merge.R $(DATA)/Sampled_Data_Business.csv $(DATA)/Sampled_Data_Review.csv
	Rscript merge.R

$(DATA)/Sampled_Data_Business.csv $(DATA)/Sampled_Data_Review.csv: download.R 
	Rscript download.R