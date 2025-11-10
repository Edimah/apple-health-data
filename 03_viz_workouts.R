# 02_viz_workouts.R
# Visualise Apple Health workouts using Plotly

library(vroom)
library(dplyr)
library(ggplot2)
library(plotly)
library(forcats)
library(lubridate)

# ------------------------------
# LOAD DATA
# ------------------------------
workouts <- vroom("apple-health-data/data/health_data_workout.csv", col_types = cols())

# ------------------------------
# CLEAN WORKOUT TYPES : removing useless prefix
# ------------------------------
workouts <- workouts %>%
  mutate(workoutActivityType = gsub("HKWorkoutActivityType", "", workoutActivityType))

# ------------------------------
# PLOT: Workout Type Distribution
# ------------------------------
asc_freq_workouts <- workouts %>%
  mutate(workoutActivityType = fct_rev(fct_infreq(workoutActivityType)))

p <- ggplot(asc_freq_workouts, aes(x = workoutActivityType, fill = workoutActivityType)) +
  geom_bar() +
  coord_flip() +
  labs(
    title = "Distribution of Workout Activity Types",
    x = "Workout Activity Type",
    y = "Count"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Display interactive plotly
ggplotly(p)
