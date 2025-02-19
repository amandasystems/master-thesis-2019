PYGMENTS_VENV = salman

all: Thesis.pdf

clean:
	latexmk -CA
	rm -rf _minted-Thesis

Thesis.pdf: Thesis.tex bibliography.bib
	latexmk \
		-pdf \
		-xelatex \
    -shell-escape \
    -file-line-error \
    -halt-on-error \
    $< \
	&& source deactivate

%.pdf: %.tex
	source activate $(PYGMENTS_VENV) \
	&& latexmk \
		-pdf \
		-xelatex \
    -shell-escape \
    -file-line-error \
    -halt-on-error \
    -interaction=nonstopmode \
    $< \
	&& source deactivate

.PHONY: diff
diff:
	git latexdiff \
		--ignore-makefile \
		--xelatex \
		--biber \
    --latexmk \
	  --latexopt -shell-escape \
    --verbose \
	HEAD^

%.pdf: %.dot
	dot -Tpdf -o $@ $<

.PHONY: howmanywords
howmanywords:
	git diff --word-diff=porcelain Thesis.tex | grep -e '^+[^+]' | wc -w
