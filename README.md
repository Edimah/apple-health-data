# Apple Health Data Analysis with R

This repository contains R scripts to **import**, **clean**, and **visualise** Apple Health data.
So far it imports the raw file (`export.xml`), parses it into tidy CSV files and creates interactive plots to explore your activity distribution.

More functions will follow such as other graphs for other data nodes, inference, trend analysis and forecasting, etc.

⚠️ For privacy reasons, this repo **does not** include any sample data.

## Getting Started

### Exporting Apple Health data

1. Open the Health app on your iPhone.
2. Tap profile picture → Export Health Data.
3. Save the exported `export.zip`.

Once unzipped, the resulting folder will contain these files:

- `export.xml` — the main XML file containing nearly all your Apple Health data (heart rate, workouts, activity summaries, etc.).

- `export_cda.xml` — a duplicate of your data in _Clinical Document Architecture_ (medical admin standard) format.

And possibly other folders depending on device usage, e.g., sleep or mindfulness data.
A few examples :

- `electrocardiograms/` — ECG data.

- `workout-routes/` — GPS route data for workouts.

In this project, I focused on `export.xml` for readability and reproducibility.

### Placing export in the repo 📂

Put `export.xml`in `apple-health-data/data/export.xml`.

⚠️ Change name and path if needed.

### Importing and cleaning the data

Run `r source("01_import_health_data.R") `
It will :

- Parse the XML export.
- Select nodes of interest. Mine were "Workout", "WorkoutStatistics", and "ActivitySummary".
- Convert them into tidy tibbles.
- Transform date strings into R date-time objects.
- Transform numeric strings into floats.
- Remove unnecessary prefixes in activity names (`HKWorkoutActivityType`).
- Save cleaned CSVs in `data/`.

### Visualising the data

Run `r source("02_visualise_health_data.R")`
It will :

- Load the cleaned CSV files (`health_data_workout.csv`, `health_data_workoutstatistics.csv`, `health_data_activitysummary.csv`).
- Generate interactive plots using ggplot2 and plotly.
- Display distributions of workout types directly in R.

## Requirements

### R packages used

xml2, dplyr, purrr, lubridate, readr, vroom, ggplot2, plotly, htmlwidgets, viridis, forcats

Install with : `r install.packages(c("xml2","dplyr","purrr","lubridate","readr","vroom","ggplot2","plotly","htmlwidgets","viridis","forcats"))`.
