TEMP = ../../gen/temp
OUTPUT = ../../gen/output
DATA = ../../data

$(OUTPUT)/report.pdf: ../../reporting/report.Rmd $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png $(OUTPUT)/table_RQ1.png $(OUTPUT)/table_RQ2.png
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('report.Rmd', output_file='$(OUTPUT)/report.pdf')"

$(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png $(OUTPUT)/table_RQ1.png $(OUTPUT)/table_RQ2.png: analysis.R $(OUTPUT)/Yelp_clean_aggregated.csv $(OUTPUT)/Yelp_clean.csv
	Rscript analysis.R

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