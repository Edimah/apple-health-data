# 01_import_health_data.R
# Script to import Apple Health XML export and convert to CSVs for analysis

library(xml2)
library(dplyr)
library(purrr)
library(lubridate)

# ------------------------------
# CONFIGURATIONS
# ------------------------------
input_file <- "personal-projects/data/health_data_export.xml"  # user's export: rename accordingly
output_path <- "apple-health-data/data/"            # CSV output folder
n_preview <- 3                   # number of nodes to preview per node type

# ------------------------------
# LOAD XML FILE
# ------------------------------
health_data <- read_xml(input_file)
root <- xml_root(health_data)

# ------------------------------
# LIGHTWEIGHT EXPLORATION OF ALL NODE TYPES
# ------------------------------
message("Exploring node types and their attributes (preview)...")
all_nodes <- xml_find_all(root, "//*")
node_types <- unique(xml_name(all_nodes))
message("Total unique node types:", length(node_types))

preview_node_type <- function(tag, n_preview = 3) {
  nodes <- xml_find_all(root, paste0(".//", tag))
  n_nodes <- length(nodes)
  cat("\nNode type:", tag, "- total nodes:", n_nodes, "\n")
  if (n_nodes == 0) return()
  # Preview first n_preview nodes
  attrs_preview <- lapply(nodes[1:min(n_nodes, n_preview)], xml_attrs)
  for (i in seq_along(attrs_preview)) {
    cat(" → Node", i, "attributes:\n")
    print(attrs_preview[[i]])
  }
}

# Preview the first 3 nodes per type
for (tag in node_types) {
  preview_node_type(tag, n_preview)
}

# ------------------------------
# SELECT NODES OF INTEREST
# ------------------------------
# I thought these were most relevant to me analysis, but feel free to modify
# You might need to adjust the cleaning function below if you add more node types
node_types_of_interest <- c("Workout", "WorkoutStatistics", "ActivitySummary")

# ------------------------------
# HELPER FUNCTION
# ------------------------------
# Convert date strings to POSIXct and numeric-like strings to numeric
clean_types <- function(df) {
  df %>%
    mutate(across(everything(), ~ {
      colname <- cur_column()
      if (colname == "date" || grepl("Date", colname, ignore.case = TRUE)) {
        parsed <- suppressWarnings(ymd_hms(.x))
        if (all(is.na(parsed))) parsed <- suppressWarnings(ymd(.x))
        parsed
      } else {
        nums <- suppressWarnings(as.numeric(.x))
        if (all(is.na(nums))) .x else nums
      }
    }))
}

# ------------------------------
# EXTRACT AND CLEAN NODE TYPES
# ------------------------------
message("\nExtracting and cleaning selected node types...")
node_types_list <- lapply(node_types_of_interest, function(tag) {
  message("Processing <", tag, "> nodes...")
  nodes <- xml_find_all(root, paste0(".//", tag))
  if (length(nodes) == 0) {
    message(" → No <", tag, "> nodes found. Returning empty tibble.")
    return(tibble())
  }
  df <- map_dfr(nodes, ~ as.list(xml_attrs(.x))) %>% as_tibble()
  df <- clean_types(df)
  # Preview first few rows
  message(" → Preview first 3 rows of <", tag, ">:")
  print(head(df, 3))
  df
})

names(node_types_list) <- node_types_of_interest

# ------------------------------
# SAVE CSV FILES
# ------------------------------
message("\nSaving CSV files...")
for (name in names(node_types_list)) {
  df <- node_types_list[[name]]
  if (!is.null(df) && nrow(df) > 0) {
    filename <- paste0("health_data_", tolower(name), ".csv")
    write.csv(df, file.path(output_path, filename), row.names = FALSE)
    message("Saved ", nrow(df), " rows to ", filename)
  } else {
    message(" → Skipped <", name, "> (no data).")
  }
}