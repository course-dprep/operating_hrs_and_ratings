TEMP = ../../gen/temp
OUTPUT = ../../gen/output
DATA = ../../data

all: $(OUTPUT)/Yelp_clean_aggregated.csv $(OUTPUT)/exploration.pdf 

$(OUTPUT)/Yelp_clean_aggregated.csv: aggregated.R $(OUTPUT)/Yelp_clean.csv
	Rscript aggregated.R

$(OUTPUT)/Yelp_clean.csv: clean.R $(TEMP)/Yelp.csv
	Rscript clean.R

$(OUTPUT)/exploration.pdf: exploration.Rmd $(TEMP)/Yelp.csv
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('exploration.Rmd', output_file='$(OUTPUT)/exploration.pdf')"

$(TEMP)/Yelp.csv: merge.R $(DATA)/Sampled_Data_Business.csv $(DATA)/Sampled_Data_Review.csv
	Rscript merge.R

$(DATA)/Sampled_Data_Business.csv $(DATA)/Sampled_Data_Review.csv: download.R 
	Rscript download.R