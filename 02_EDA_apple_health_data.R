library(vroom)

# Load Data
workouts <- vroom("apple-health-data/data/health_data_workout.csv", col_types = cols()) # nolint: line_length_linter.
workout_stats <- vroom("apple-health-data/data/health_data_workout.csv", col_types = cols()) # nolint: line_length_linter.
activity_summary <- vroom("apple-health-data/data/health_data_activitysummary.csv", col_types = cols()) # nolint: line_length_linter.
