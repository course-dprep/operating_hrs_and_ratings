OUTPUT = ../../gen/output

all: $(OUTPUT)/table_RQ1.png $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/table_RQ2.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png

$(OUTPUT)/Yelp_clean_aggregated.csv: 
	make -C ../data-preparation -f Makefile first 

$(OUTPUT)/Yelp_clean.csv:
	make -C ../data-preparation -f Makefile first 

$(OUTPUT)/table_RQ1.png $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png: RQ1_analysis.r $(OUTPUT)/Yelp_clean_aggregated.csv
	Rscript RQ1_analysis.R

$(OUTPUT)/table_RQ2.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png: RQ2_analysis.r $(OUTPUT)/Yelp_clean.csv
	Rscript RQ2_analysis.R
