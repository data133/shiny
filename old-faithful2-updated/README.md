# Old Faithful

This is a Shiny app that graphs a histogram of the variables in the `faithful`
data frame, which is based on the famous _Old Faithful_ geyser located in 
Yellowstone National Park.

<https://en.wikipedia.org/wiki/Old_Faithful>

This Shiny app is a modified (updated) version of the default _Old Faithful_
app. In addition to the input slider for selecting the number of bins, this
app also includes a select input-widget to choose the variable to be graphed.


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
  subdir = "old-faithful2-updated")
```

