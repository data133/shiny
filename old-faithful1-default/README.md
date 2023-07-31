# Old Faithful

This is a Shiny app that graphs a histogram of waiting times till next eruption 
of the famous _Old Faithful_ geyser located in Yellowstone National Park.

<https://en.wikipedia.org/wiki/Old_Faithful>


## Data

This app uses the built-in data set `faithful` which is a data frame with
272 observations on 2 variables.

- `eruptions`: Eruption time in minutes.

- `waiting`: Waiting time to next eruption (in minutes).


## How to run it?

One quick way to run the app is with the `"shiny"` function `runGitHub()` as follows:

```R
library(shiny)

runGitHub(
  repo = "shiny", 
  username = "data133", 
  subdir = "old-faithful1-default")
```

