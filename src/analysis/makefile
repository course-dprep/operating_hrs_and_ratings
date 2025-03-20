OUTPUT = ../../gen/output

$(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png $(OUTPUT)/table_RQ1.png $(OUTPUT)/table_RQ2.png: analysis.R $(OUTPUT)/Yelp_clean_aggregated.csv $(OUTPUT)/Yelp_clean.csv
	Rscript analysis.R