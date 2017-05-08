paper.pdf: paper.tex paper.bib
	pdflatex -shell-escape -halt-on-error paper.tex
	bibtex paper
	pdflatex -shell-escape -halt-on-error paper.tex
	pdflatex -shell-escape -halt-on-error paper.tex

clean:
	rm paper.aux paper.log paper.blg paper.bbl paper.pdf
