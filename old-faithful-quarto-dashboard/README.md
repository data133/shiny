# Old Faithful Quarto Dashboard

This is a Shiny app implemented in a Quarto dashboard. You can find more
information about dashboards in:

<https://quarto.org/docs/dashboards/interactivity/shiny-r.html>


The app graphs a histogram of the variables in the `faithful`
data frame, which is based on the famous _Old Faithful_ geyser located in 
Yellowstone National Park.

<https://en.wikipedia.org/wiki/Old_Faithful>


## Input Widgets

- Slider input to select the number of bins.

- Select input-widget to choose the variable to be graphed.

- Checkbox widget to decide whether the mean time should be displayed.


## Data

This app uses the built-in data set `faithful` which is a data frame with
272 observations on 2 variables.

- `eruptions`: Eruption time in minutes.

- `waiting`: Waiting time to next eruption (in minutes).

