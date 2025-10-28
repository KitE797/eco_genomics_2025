# Load libraries
library(tximport)
library(readr)

# Path to sample table
samples <- read.csv("/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/myresults/samples.csv")

# Make a named vector of quant.sf file paths
files <- file.path(samples$path, "quant.sf")
names(files) <- samples$sample

# Import Salmon quantifications
txi <- tximport(files, type = "salmon", txOut = TRUE)

# Write counts to txt
write.table(txi$counts, "/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/mydata/counts_matrix.txt")

## Can create a csv file instead using this:
#write.csv(txi$counts, "/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/mydata/counts_matrix.csv")
