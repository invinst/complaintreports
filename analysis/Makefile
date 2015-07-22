all : cr_modeling.pdf

cr_modeling.pdf : cr_modeling.Rnw
	Rscript -e "library(knitr); knit2pdf('$<'); knit2pdf('$<');"
