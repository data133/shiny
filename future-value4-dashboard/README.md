# Yet Another Basic Investing Simulator

This app simulates investing periodic contributions at the end of the year, for 
a number of years. 
The rate of return for every year is a variable rate that is randomly generated according to a normal distribution.


## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "future-value4-dashboard")
```

