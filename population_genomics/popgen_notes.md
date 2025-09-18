# Population Genomics Notebook

## Fall 2025 Ecological Genomics

## Author: Kit Eller

This will keep my notes on population genomics coding sessions.

### 09/11/25: Cleaning fastq reads of red spruce

-   We wrote a bash script, fastp.sh, located in my Github repo:

`~/projects/eco_genomics_2025/population_genomics/myscripts`

-   This was used to trim the adapters out of the red spruce fastq sequence files.

-   My assigned population was 2101.

-   The raw fastq files were located in the class share space:

`/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/fastq/red_spruce`

-   Using the program fastp, we processed the raw reads and output the cleaned reads to the following directory in the class shared space:

`/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/cleanreads`

-   Fastp produced reports for each sample, which I saved into the directory:

`~/projects/eco_genomics_2025/population_genomics/myresults/fastp_reports`

-   Results showed high quality sequence, with most Q-scores being \>\>20, and amount of adapted contamination, which we trimmed out. We also trimmed out the leading 12 bp to get rid of the barcoded indices.

-   Cleaned reads are now ready to proceed to the next step in our pipeline: mapping to the reference genome.

### 9/16/25: Mapping cleaned reads to the reference genome

-   Set up lab notebook
-   We wrote a bash script, mapping.sh, which uses bwa.mem2 to map our specific population sample clean reads to the black spruce reference genome
-   Reference genome here:
    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome/Pmariana/Pmariana1.0-genome_reduced.fa`
-   The resulting sam files were saved to the class shared space:
    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`
-   This was submitted to SLURM using sbatch, requesting 10 CPU and 64G ram
    -   We had a problem with the nodes, had to keep resubmitting until randomly getting a node that works
-   Going to put two scripts into a wrapper (process_bam.sh and bam_stats.sh)
    -   process_bam.sh: processing the bams, uses program sambamba to convert sam to bam, sort, remove PCR dupes, and index
    -   bam_stats.sh: get mapping and coverage stats from our alignment
    -   After mapping.sh finishes running, I will submit this to SBATCH

### 9/18/25: Review bam stats and setting up nucleotide diversity estimation using ANGSD

-   Create new file to review our bam stats (found in 2101.stats.txt) to evaluate mapping success
    -   Tried to do this, not working for me. Going to fix later
-   Created a new script called `ANGSD.sh`
    -   Creates the list of bam files
-   Creating a wrapper
    -   Leaving scripts to run over weekend
