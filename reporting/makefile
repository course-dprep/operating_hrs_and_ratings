OUTPUT = ../../gen/output

$(OUTPUT)/report.pdf: ../../reporting/report.Rmd $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png $(OUTPUT)/table_RQ1.png $(OUTPUT)/table_RQ2.png
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('report.Rmd', output_file='$(OUTPUT)/report.pdf')"