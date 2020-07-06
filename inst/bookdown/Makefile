all: pdf gitbook

gitbook: *Rmd
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

pdf: *Rmd
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
