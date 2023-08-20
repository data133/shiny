# Simple Future Value Timeline

This is a Shiny app that produces a timeline to visualize a simple Future Value
calculation of a lump sum investment.


## Inputs

This app takes three inputs (using slider input widgets):

- Initial amount

- Interest Rate (i.e. annual rate of return)

- Years



## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "future-value2-sliders")
```

