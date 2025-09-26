# Apple Health Data

This repository contains anonymised Apple Health data and R scripts for importing, cleaning, and visualising personal fitness metrics.  

I have been collecting health data using my iPhone and Apple Watch for almost two years. I was curious what could be gleaned from it. So far, in this repo I have explored: 

- **Exporting Apple Health data** from an iPhone,
- **Importing and parsing XML** with `xml2`  
- **Cleaning and tidying** the data with `dplyr` and `lubridate`  
- Creating **interactive visuals** using `ggplot2` and `plotly`  

I will add more as I go.

---

## Structure

apple-health-data/
├─ README.md
├─ data/ # anonymised CSVs
├─ R/ # R scripts for parsing, cleaning, plotting
├─ assets/html/ # interactive Plotly plots for sharing or embedding


## Usage

1. Clone the repo,
2. Open R scripts in R/ to reproduce analyses,
3. Visualise plots saved to assets/html/.

**Notes**
The data is anonymised and safe for public sharing.
Future updates will include more visualisations and summaries from Apple Health metrics.

