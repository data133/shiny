# Mapping Storms in the North Atlantic

This is a Shiny app to visualize the path of storms in the North Atlantic 
(in a given year), to display relevant information of the storms, and to 
get a view of some summary statistics for all years.

The app layout is divided in three tabs, each with their own input widgets:

1) map
2) table
3) summary


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
  subdir = "mapping-storms3-tabsets")
```

