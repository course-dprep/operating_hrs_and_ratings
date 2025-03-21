OUTPUT = ../../gen/output

all: report.pdf

$(OUTPUT)/table_RQ1.png $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/table_RQ2.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png:
	make -C ../src/analysis -f Makefile all 

report.pdf: report.Rmd $(OUTPUT)/table_RQ1.png $(OUTPUT)/star_rating_by_opening_hours.png $(OUTPUT)/predicted_probabilities.png $(OUTPUT)/table_RQ2.png $(OUTPUT)/residuals_vs_fitted.png $(OUTPUT)/predicted_sentiment_scores.png
	Rscript -e "if (!require(rmarkdown)) install.packages('rmarkdown')"
	Rscript -e "rmarkdown::render('report.Rmd', output_file='report.pdf')"

