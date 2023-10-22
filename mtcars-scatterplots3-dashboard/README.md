# Scatterplots of `mtcars` variables

This is a Shiny app that generates a scatterplot---via `"ggplot2"`---to 
visualize and explore the relationship of variables in `mtcars`. Likewise,
it also renders a Data Table with the selected variables, and the transmission
(variable `am`) of the cars.

On the layout side of things, this app is shiny dashboard app based on the
package `"bslib"`. To see more information about shiny dashboards go to:

<https://rstudio.github.io/bslib/>


## Data `mtcars`

This app uses `mtcars` which is a built-in data set in R that contains 
variables measured on cars (data from early 1970s):

- `mpg`: Miles/(US) gallon
- `cyl`: Number of cylinders
- `disp`: Displacement (cu.in.)
- `hp`: Gross horsepower
- `drat`: Rear axle ratio
- `wt`: Weight (1000 lbs)
- `qsec`: 1/4 mile time
- `vs`: Engine (0 = V-shaped, 1 = straight)
- `am`: Transmission (0 = automatic, 1 = manual)
- `gear`: Number of forward gears
- `carb`: Number of carburetors



## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "mtcars-scatterplots3-dashboard")
```

