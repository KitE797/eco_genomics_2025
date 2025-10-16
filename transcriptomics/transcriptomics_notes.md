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

# 10/14/25:

-   Looked at the mapping rate-- pretty low, less than 60% or 40% for most
    -   Discussed factors that could affect mapping rate.
        -   Contamination of reads from other taxa that wouldn't map to reference transcriptome, algae, microbes, a different clade
        -   Low RNA quality, low RNA yield, used low input RNA prep
        -   Could try with a new head crop in the cleaning of the reads in the event that the primers are affecting mapping rate
        -   Could do a new de nova assembly from these reads (would need to annotate)
-   Saved a mapping rate file: `mapping_rate_list.txt`
-   Now in R making a counts matrix using `tximport`!
-   DESeq2 start of data analysis:
    -   
    
# 10/16/25:

- Continuing from 10/14/25

- Note: can use heatmap as part of looking for problematic samples
