# Copyright © 2013, authors of the "Notes on Macroeconometrics"
# textbook; a complete list of authors is available in the file
# AUTHORS.tex.

# Permission is granted to copy, distribute and/or modify this
# document under the terms of the GNU Free Documentation License,
# Version 1.3 or any later version published by the Free Software
# Foundation; with no Invariant Sections, no Front-Cover Texts, and no
# Back-Cover Texts.  A copy of the license is included in the file
# LICENSE.tex and is also available online at
# <http://www.gnu.org/copyleft/fdl.html>.

.PHONY: all clean burn ver
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent

all: textbook.pdf

textbook.pdf: textbook.tex AUTHORS.tex LICENSE.tex $(wildcard tex/*.tex) \
  tex/tufte-handout.cls tex/tufte-common.def tex/references.bib VERSION.tex
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi

# The rest of the Makefile extracts the last tag and the date of the
# current commit from the gitrep, and writes it to the file
# VERSION.tex formatted to be used as the date for the LaTeX textbook.

ver:
	echo $(dateinfo) > VER.tmp
	if diff --brief VERSION.tex VER.tmp; then rm VER.tmp; \
  else mv -f VER.tmp VERSION.tex; fi
VERSION.tex:
	echo $(dateinfo) > $@

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  $(shell git describe --tags)}"
