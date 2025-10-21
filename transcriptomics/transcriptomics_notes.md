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
-   Started DESeq2 data analysis in `DESeq2_log.Rmd`

# 10/16/25:

-   Continuing from 10/14/25

-   Continuing DESeq2 analysis in `DESeq2_log.Rmd`, located in `mydocs`

-   Loaded in our libraries, and imported our counts matrix, `counts_matrix.txt`, which we had made in `create_counts_matrix.r` located in `myscripts`

-   Note that DESeq2 needs rounded numbers to work

-   Also imported the metatable, `metatable.txt`, which had been in class directory but now copied over to `mydata`

-   Looked at average number of reads per sample-- we are below rule of thumb of 20M, we are at around \~12M

-   Started actually looking at our DESeq2 analysis, and different genes-- we had one gene that seemed to be giving significance when there wasn't actually much going on, but otherwise seems to work well

-   Note: can use heatmap as part of looking for problematic samples

# 10/21/25:

-   Reworked the differential gene expression graph so that it shows DGE for an individual gene across all generations.
-   Made an MAplot: really significant highlighted in blue. Shows relationship between LFC and magnitude of expression?
-   Made a volcano plot: tells us about relationship between LFC and significance of DGE
-   Made a heatmap: for DEGs, tells us about gene expression variation across individual samples among treatment groups
-   Made a volcano plot
-   Make a heatmap of G1 sig genes and how they change across generations
    -   Also did the same for gens 2, 3, and 4-- but mostly to look at 2, as we know 3 and 4 are very similar.
-   End of class: started trying to make scatterplots for LFC in g1 v g2, etc