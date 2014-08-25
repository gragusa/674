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

.PHONY: all clean burn
.DELETE_ON_ERROR:

SHELL=/bin/bash
latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -silent -pdf

all: macroeconometrics.pdf
macroeconometrics.pdf: $(wildcard tex/lec*.tex) \
                   references.bib tex/preamble.tex tex/macros.tex LICENSE.tex
	$(latexmk) $(latexmkFLAGS) $(@F)

clean:
	$(latexmk) -c macroeconometrics.pdf
	rm -f *~ tex/*~ *.dvi

burn: clean
	$(latexmk) -C macroeconometrics.pdf
	rm -f *.pdf *.dvi
