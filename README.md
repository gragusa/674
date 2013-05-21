A free graduate Macroeconometrics textbook
==========================================

The goal of this project is to produce and maintain as a community a
free textbook/research monograph on Macroeconometrics suitable for
teaching a PhD elective and make it available through the [GNU Free
Documentation License](http://www.gnu.org/copyleft/fdl.html).

There are a few reasons to do this. Perhaps the most important is that
there aren't appropriate textbooks for these classes: as far as I
know, Hamilton's *Time Series Analysis* is the most recent
comprehensive Econometric time-series book, but it was written in 1994
and doesn't cover many important recent developments.

The project is just getting started and is in version 0.1.3.  Use at
your own risk!

Chapters
--------

* Basic VARMA processes
* Estimating VARMA processes
* Structural Vector Autoregressions
* Stochastic integrals
* Cointegration

License
-------

Permission is granted to copy, distribute and/or modify this document
under the terms of the [GNU Free Documentation
License](http://www.gnu.org/copyleft/fdl.html), Version 1.3 or any
later version published by the Free Software Foundation; with no
Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. A
copy of the license is included in the textbook Appendix "GNU Free
Documentation License" and in the file LICENSE.tex.

Dependencies and installation
-----------------------------

Either download a zip file from
<https://github.com/EconometricsLibrary/MacroeconometricsText> and
extract the source or clone the git repo.

To build the pdfs, you'll need XeLaTeX (you may need to install some
packages manually if you use an older LaTeX distribution).

You can manually run XeLaTeX on `textbook.tex` or run
```
latexmk -pdf -pdflatex=xelatex textbook.tex
```
on the command line in the main directory of this project.  Running
```
latexmk -c textbook.tex
```
will clean up most of the files that LaTeX created in the first step.

The `latex-shared` and `tufte-latex` subdirectories are shared across
several projects.  Please do not submit patches that contain changes
to those directories.  If you think that you need to edit those files,
please propose your changes on the project mailing list.  The
"original" sources of those directories can be found on the EFL
project's GitHub page.

Please email the mailing list if you run into problems or have any
other questions.

Contact information and support
-------------------------------

There are two "best" ways of contacting us.  The first is through the
mailing list for the
[Econometrics Free Library](http://www.econometricslibrary.org),
<econometricslibrary@librelist.com> (this is the mailing list for our
parent organization); the [Librelist homepage](http://librelist.com/) has more information about sending messages to this discussion list.  The second is by
[filing an issue report for the project](https://github.com/EconometricsLibrary/MacroeconometricsText/issues/new).

If you find an error in the text, please let us know through one of
those methods.  If you'd like to contribute to this project, please
subscribe to the mailing list.

Thanks!