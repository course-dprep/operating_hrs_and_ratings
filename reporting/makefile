OUTPUT = ../../gen/output

$(OUTPUT)/report.pdf: report.Rmd $(OUTPUT)/star_rating_by_opening_hours.pdf $(OUTPUT)/predicted_probabilities.pdf $(OUTPUT)/residuals_vs_fitted.pdf $(OUTPUT)/predicted_sentiment_scores.pdf $(OUTPUT)/table_RQ1.png $(OUTPUT)/table_RQ2.png
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('report.Rmd', output_file='$(OUTPUT)/report.pdf')"
