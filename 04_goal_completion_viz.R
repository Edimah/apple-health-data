library(vroom)
library(dplyr)
library(ggplot2)
library(plotly)
library(forcats)
library(lubridate)

# ------------------------------
# LOAD : ACTIVITY SUMMARY DATA
# ------------------------------
activity_summary <- vroom("apple-health-data/data/health_data_activitysummary.csv", col_types = cols())
