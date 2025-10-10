## Transcriptomics Notes!

This is a place for me to keep my notes on our transcriptomics activities in class.

# 10/7/25:

-   We learned about the motivation and process of asking questionsing and analysing RNAseq data. We started to run fastp to clean and visualize the data quality in our fastq files, but ran into file recognition issues; going to fix on Thursday.
-   Assigned population "T4"

# 10/9/25:

Fixing our fastp stuff!

-   Fastp script name: `fastp_tonsa.sh`. Needed to fix formatting (ie, how the \* were used) and path issues in order to run properly.
-   Once it ran, it cleaned the reads for my populations and output three HTML files with information about the cleaned reads before/after (one HTML for each replicate)
-   We also ran `salmon_quant.sh` for salmon quantification. Output sent directly to `/gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant`.
