# 01_prepare_data.R
# Purpose: Load and prepare Palmer penguins data for analysis
# Output: analysis/data/derived_data/penguins_clean.csv

library(palmerpenguins)
library(tidyverse)

cat("🐧 Palmer Penguins Part 1: Data Preparation\n")
cat("=============================================\n\n")

# Load the Palmer penguins data
data(penguins)

# Basic dataset information and data quality check
cat("Dataset Overview:\n")
cat("Dimensions:", nrow(penguins), "observations ×", ncol(penguins), "variables\n")

# Check for missing values efficiently
missing_counts <- sapply(penguins, function(x) sum(is.na(x)))
cat("Missing values:", sum(missing_counts), "total\n\n")

# Create clean dataset for analysis
penguins_clean <- penguins %>% drop_na()
cat("Clean dataset:", nrow(penguins_clean), "observations (removed",
    nrow(penguins) - nrow(penguins_clean), "incomplete cases)\n\n")

# Display key variable information
cat("Data structure:\n")
glimpse(penguins_clean)

# Save cleaned data for downstream analysis
write_csv(penguins_clean, "analysis/data/derived_data/penguins_clean.csv")
cat("\n✅ Saved clean data to analysis/data/derived_data/penguins_clean.csv\n")

# Generate species summary statistics
species_summary <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    n = n(),
    body_mass_mean = round(mean(body_mass_g), 0),
    flipper_length_mean = round(mean(flipper_length_mm), 1),
    .groups = "drop"
  ) %>%
  mutate(percentage = round(n / sum(n) * 100, 1))

write_csv(species_summary, "analysis/data/derived_data/species_summary.csv")
cat("✅ Saved species summary statistics\n")

# Calculate correlation matrix
numeric_vars <- penguins_clean %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)

correlation_matrix <- cor(numeric_vars)

# Extract key correlations with body mass
body_mass_cors <- correlation_matrix["body_mass_g", ] %>%
  sort(decreasing = TRUE)

cat("\nKey Correlations with Body Mass:\n")
cat(sprintf("  Flipper Length: %.3f (strongest relationship)\n", body_mass_cors["flipper_length_mm"]))
cat(sprintf("  Bill Length: %.3f\n", body_mass_cors["bill_length_mm"]))
cat(sprintf("  Bill Depth: %.3f (negative relationship)\n", body_mass_cors["bill_depth_mm"]))

# Save correlation matrix for visualization
write.csv(correlation_matrix, "analysis/data/derived_data/correlation_matrix.csv")
cat("\n✅ Data preparation complete!\n")
