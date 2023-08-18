# Scatterplots of `mtcars` variables

This is a Shiny app that generates a scatterplot---via `"ggplot2"`---to 
visualize and explore the relationship of variables in `mtcars`.

This app uses a color picker widget---via the package `"colourpicker"`---to
set the colors of the points in the scatter plots.


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
  subdir = "mtcars-scatterplots2-colors")
```

