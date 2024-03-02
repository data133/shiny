# Barchart to visualize Top-N mtcars

This is a Shiny app that generates a barchart---via `"ggplot2"`---to 
visualize the top-n cars (from `mtcars`) given a selected variable.



## Data

This app uses the built-in `mtcars` data frame, specifically
the following quantitative variables:

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
  subdir = "mtcars-topn-barchart")
```

