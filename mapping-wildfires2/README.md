# Mapping Wildfires in California

This is a Shiny app that generates a map---via `"ggplot2"`---to 
visualize wildfires in California for a given year, while also displaying a 
table of the top-10 largest fires in the chosen year.



## Data

This app uses data from [CAL FIRE](https://www.fire.ca.gov/). To be more
precise, it uses __CAL FIRE Wildfire Perimeters and Prescribed Burns__ data 
hosted on CAL FIRE portal:

<https://gis.data.ca.gov/maps/CALFIRE-Forestry::california-fire-perimeters-all-1>

A copy of this data set is available in the `data/` folder of this repository
[California_Fire_Perimeters](../data/California_Fire_Perimeters). 
Keep in mind that this folder contains the shape files used to graph the
polygons of the fire perimeters on a map.



## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "mapping-wildfires2")
```

