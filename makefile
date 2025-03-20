all: report analysis data-preparation

data-preparation:
	make -C src/data-preparation

analysis: 
	make -C src/analysis

report: 
	make -C reporting
