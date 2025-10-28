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

# 10/23/25:

-   Going to start looking at our GO enrichment
-   Made a new Rmd file: `DESeq2toTopGO.Rmd`
-   Looking at our Pvalues
-   Actually running the GO analysis!
    -   Bigger is more significant genes, darker more significant
-   Also ran revigo

# 10/28/25:

-   Starting Weighted Gene Correlation Network Analysis (WGCNA)
-   Creating a new rmd file `WGCNA.rmd` , located in mydocs
    -   Loaded libraries
    -   Imported counts/sample description table
    -   Copying `WGCNATrait_Data.csv` over from class directory into mydata
    -   Importing this phenotypic data into dataset, then filtering for samples we have trait data for, then for only the top 50%. Creating a subset matrix dataset from that
    -   Setting up soft thresholds:
        -   0.8 is recommended, which is why we set the yintercept to that
        -   Want to be at an R2 above 0.8 but have a mean connectivity that's actually biologically meaningfully (ie, not too many bins with not enough stuff in them)
        -   Having everyone go around and choose different amount of soft-power (from 16-24)-- I will be doing 21
        -   Using `blockwiseModules()` to actually start creating our network
        -   Got 18 modules using this. Grey modules should be the largest, catch-all of things that aren't really correlated with other things
    -   Cyan ended up being my most significiant bin, with r=0.43
    -   Not enough genes to do a full GO analysis– instead we're going to see what those GO terms actually are from using REVIGO
    -   Revigo sorted it into two (biological) categories:
        -   phosphate-containing compound metabolic process
        -   proton motive force-driven ATP synthesis
