# Shiny Apps for STAT 133

This repository contains some of the shiny apps used in 
**STAT 133 Concepts in Computing with Data** (with Prof. Gaston Sanchez 
at UC Berkeley).


## Software Requirements

The required software is __[R](https://www.r-project.org/)__ and
__[RStudio](https://www.rstudio.com/)__ (preferably a recent version).

You will also need to have installed the following packages:

- `"shiny"`
- `"tidyverse"`
- `"tidytext"`
- `"plotly"`
- `"sf"`
- `"rnaturalearth"`
- `"leaflet"`
- `"bslib"`



## Running the apps

The easiest way to run an app is with the `runGitHub()` function from the 
`"shiny"` package. For instance, to run the app contained in the folder 
[old-faithful1-default](/old-faithful1-default), run the following code in R:

```R
library(shiny)

# Run an app from a subdirectory in the repo
runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "old-faithful1-default")
```



-----

### License

This work is licensed under a <a rel="license" href="https://opensource.org/licenses/BSD-2-Clause">FreeBSD License</a>.

Author: [Gaston Sanchez](https://www.gastonsanchez.com)
