# Mapping Storms in the North Atlantic

This is a Shiny app that generates an interactive map to visualize storms in 
the North Atlantic for a given year.

The displayed map is a `"plotly"` graphic that is generated
by passing a `"ggplot"` object to `ggplotly()`.


## Data

This app uses the `storms` data from the tidyverse package `"dplyr"`.
This dataset is the NOAA Atlantic hurricane database best track data,
<https://www.nhc.noaa.gov/data/#hurdat>. The data includes the positions and 
attributes of storms from 1975-2021.


## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "mapping-storms2-ggplotly")
```

