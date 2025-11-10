library(dplyr)
library(purrr)
library(readr)
library(vroom)

#################
### Load Data ###
#################

# import all data all at once
data_dir <- if (dir.exists("data")) "data" else "apple-health-data/data"
data_sources <- list(
    workouts = file.path(data_dir, "health_data_workout.csv"),
    workout_stats = file.path(data_dir, "health_data_workoutstatistics.csv"),
    activity_summary = file.path(data_dir, "health_data_activitysummary.csv")
)

data_list <- imap(
    data_sources,
    ~ vroom(.x, col_types = cols())
)

workouts <- data_list$workouts
workout_stats <- data_list$workout_stats
activity_summary <- data_list$activity_summary

summarise_schema <- function(df, dataset_name) {
    tibble(
        dataset = dataset_name,
        column = names(df),
        type = map_chr(df, ~ paste(class(.x), collapse = "/")),
        n_unique = map_int(df, ~ n_distinct(.x, na.rm = TRUE)),
        n_missing = map_int(df, ~ sum(is.na(.x))),
        pct_missing = round(n_missing / max(1, nrow(df)) * 100, 2),
        example_values = map_chr(
            df,
            ~ paste(utils::head(unique(na.omit(.x)), 3), collapse = "; ")
        )
    )
}

schema_summary <- imap_dfr(data_list, summarise_schema)
schema_summary_path <- file.path("data", "health_data_schema_summary.csv")
write_csv(schema_summary, schema_summary_path)
message("Column summary written to: ", schema_summary_path)

####################
### Preview data ###
####################

walk2(
    data_list,
    names(data_list),
    ~ {
        message("\n===== ", .y, " =====")
        glimpse(.x)
        head(.x)
        tail(.x)
    }
)

schema_summary
