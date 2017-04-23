paper.pdf: paper.tex paper.bib
	pdflatex paper.tex
	bibtex paper
	pdflatex paper.tex
	pdflatex paper.tex

clean:
	rm paper.aux paper.log paper.blg paper.bbl paper.pdf
