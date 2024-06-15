library(arrow)
library(stringr)
library(reticulate)
np <- import("numpy")

setwd("C:/Users/olive/Downloads")
npz_file <- file.choose()
data <- np$load(npz_file)

x <- data[['X']]
y <- data[['y']]

df <- as.data.frame(cbind(x, y))
colnames(df)[ncol(df)] <- "Class"

# Path
out_path <- "C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/resources/input"

# File
file_name <- tools::file_path_sans_ext(basename(npz_file))
file_name <- gsub("^[0-9]+_", "", file_name)
file_name <- gsub("_", ".", tolower(file_name))
file_name <- paste0(file_name, ".parquet")

# Directory
out_dir <- str_split(file_name, pattern="[.]")[[1]][1]

path <- paste0(out_path, "/", out_dir, "/", file_name)
arrow::write_parquet(df, path)
