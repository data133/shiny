# Scatterplots of NBA players' variables

This is a Shiny app that generates a scatterplot---via `"ggplot2"`---to 
visualize the relationship of some NBA players' data.



## Data

This app uses data from NBA players (regular season 2022), specifically
the following quantitative variables:

- `height`: height (in inches) of players,
- `weight`: weight (in pounds) of players,
- `age`: age (in years) of players, 
- `experience`: years of experience playing in the NBA,
- `salary`: salary (in dollars) of players,
- `points3`: triple pointers made by players,
- `points2`: double pointers made by players,
- `points1`: free throws made by players,
- `total_rebounds`: total rebounds (offensive + defensive) made by players,
- `assists`: number of assists made by players,
- `blocks`: number of blocks made by players,
- `turnovers`: number of turnovers made by players.



## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "nba-scatterplots1-basic")
```

