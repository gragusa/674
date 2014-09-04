Project news
============

### Version 0.2.2
* Restores ARMA estimation material

### Version 0.2.1
* Switches back from unicode to ascii characters

Version 0.2.0
-------------
Changes project ownership to 'Gray Calhoun' and removes the project
from EFLP (because it's underdeveloped).

### Version 0.1.4 (minor changes)
* Updates the makefile to generate date and version information
  automatically with 'make ver'
* Moves material from shared repositories into this repo to free us up
  from worring about interop while we're doing the first real draft.
* Adds some material to the README file (rss feed location)
* Moves the authors into a separate tex file and appendix for convenience

### Version 0.1.3 
* Finishes the process of importing Calhoun's lecture notes; adds to
  the VAR and Cointegration notes and in particular some Bayesian
  stuff.
* Changes the name and author to be slightly more descriptive.
* Fixes some formatting and numbering issues.
* Starts a bibliography section (admittedly, without entries yet).

### Version 0.1.2
Another bugfix release: the previous patch messed up sectioning in the
GNU FDL section; that's been fixed.

### Version 0.1.1
Bugfix release: chapter headings were not displayed, so they've been
converted to 'parts' instead.

Version 0.1.0
-------------
Refactors the previous version.
- Adds the LaTeX class as a local subtree (to a mirror hosted by the
  parent project.
- Moves the preamble to a file shared across different projects.
- Updates the code in the preamble so that the author & title entries
  work.

### Version 0.0.1
Adds some Econometric content.  This commit introduces some
(disorganized) notes on
- VARMA processes
- Structural VARs and Impulse Response Functions
- Stochastic Integration
- Cointegration