# Population Genomics Notebook

## Fall 2025 Ecological Genomics

## Author: Kit Eller

This will keep my notes on population genomics coding sessions.

### 09/11/25: Cleaning fastq reads of red spruce

-   We wrote a bash script, fastp.sh, located in my Github repo:

    -   `~/projects/eco_genomics_2025/population_genomics/myscripts`

-   This was used to trim the adapters out of the red spruce fastq sequence files.

-   My assigned population was 2101.

-   The raw fastq files were located in the class share space:

    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/fastq/red_spruce`

-   Using the program fastp, we processed the raw reads and output the cleaned reads to the following directory in the class shared space:

    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/cleanreads`

-   Fastp produced reports for each sample, which I saved into the directory:

    -   `~/projects/eco_genomics_2025/population_genomics/myresults/fastp_reports`

-   Results showed high quality sequence, with most Q-scores being \>\>20, and amount of adapted contamination, which we trimmed out. We also trimmed out the leading 12 bp to get rid of the barcoded indices.

-   Cleaned reads are now ready to proceed to the next step in our pipeline: mapping to the reference genome.

### 9/16/25: Mapping cleaned reads to the reference genome

-   Set up lab notebook

-   We wrote a bash script, `mapping.sh`, which uses bwa.mem2 to map our specific population sample clean reads to the black spruce reference genome

-   Reference genome here:

    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome/Pmariana/Pmariana1.0-genome_reduced.fa`

-   The resulting sam files were saved to the class shared space:

    -   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`

-   This was submitted to SLURM using sbatch, requesting 10 CPU and 64G ram

    -   We had a problem with the nodes, had to keep resubmitting until randomly getting a node that works

-   Going to put two scripts into a wrapper (`process_bam.sh` and `bam_stats.sh`)

    -   `process_bam.sh`: processing the bams, uses program sambamba to convert sam to bam, sort, remove PCR dupes, and index

    -   `bam_stats.sh`: get mapping and coverage stats from our alignment

    -   After mapping.sh finishes running, I will submit this to SBATCH

### 9/18/25: Review bam stats and setting up nucleotide diversity estimation using ANGSD

-   Created new script to review our bam stats (`2101.stats.txt`) to evaluate mapping success

    -   New file called `bamstats_review.r`.
    -   Located in `/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`
    -   Tried to do this, not working for me. Going to troubleshoot later
    -   9/26/25: Finally got to work, had to manually make sure all separators were either tab or space– it had been mixed for some reason

-   Created a new script called `ANGSD.sh`

    -   Creates the list of bam files, then estimates Genotype Likelihoods (GLs)
    -   Located in `/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`

-   Created another script called `ANGSD_doTheta.sh`

    -   Created to estimate nucleotide diversities
    -   Located in `/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`
    -   First has to estimate Site Frequency Spectrum (SFS), then estimates thetas and neutrality stats
    -   Cut command at end most likely what failed (see below)

-   Creating a wrapper (`diversity_wrapper.sh`) to run both `ANGSD.sh` and `ANGSD_doTheta.sh`

    -   Runs first `ANGSD.sh`, then `ANGSD_doTheta.sh`
    -   Located in `/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`
    -   Leaving scripts to run over weekend
    -   Script failed after running (ExitCode 127)
        -   Did not have the `.thetasWindow.gz.pestPG` file
        -   Realised that I accidentally wrote `ANGDS_doTheta.sh` instead of `ANGSD_doTheta.sh` (D and S switched) in the wrapper, so it failed because of that– resubmitted at 3:00pm on 9.19.25 to rerun, will hopefully work now
        -   9/23/25: Worked! Produced:
            -   `2101_ALL.sfs`
            -   `2101_ALL_win50000_step50000.thetas`
            -   `2101_ALL_win50000_step50000.thetasWindow.gz.pestPG`
            -   `2101_ALL_win_step.thetas`
            -   These files all located in `~/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/diversity`

### 9/23/25: Reviewing nucleotide diversity for my population

-   Fixed the 'cut' command in the ANGSD.sh script-- just ran in terminal to fix end file
-   Created an rmarkdown file called `Nucleotide_Diversity.Rmd` to explore `2101_ALL_win50000_step50000.thetas`
    -   Located in `/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/population_genomics/mydocs/Nucleotide_Diversity.Rmd`
    -   Pulled out different diversity metrics for population 2101, which were shared with the whole class on a google sheet: <https://docs.google.com/spreadsheets/d/1SLwhW3OgQiX2z1rxH-ske236NYxjDXCvUu0l8XFeS_w/edit?usp=sharing>

### 9/25/25: Calculating Fst and admixture for red spruce vs black spruce

-   Created a bash script called `ANGSD_Fst.sh` to calculate Fst between my pop (2101) and the black spruce population
    -   Script located in `/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`
    -   Black spruce input saf.idx data located `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ANGSD/black_spruce`
    -   Produced:
        -   `2101_WISC_2D.sfs`
        -   `2101_WISC_Fst_50kbWindows.txt`
        -   `2101_WISC_Fst.txt`
        -   Located in `~/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/Fst`
-   Also created a bash script called `PCAngsd_RCBS.sh` to use PCAngsd (iterative approach that refines estimation of allele frequencies for each individual as it finds clusters that the individual may have ancestry in)
    -   Important options included 'K' (\# of groups or clusters to assign ancestry to). K = number of PCA eigenvalues + 1.
    -   Script located in `/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`
    -   Input beagle file (which has the genotype likelihoods) is located in `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ANGSD/RSBS_poly.beagle.gz`
        -   Code for calculating genotype likelihoods is located in `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/scripts/ANGSD_RSBS_poly.sh`
    -   Couldn't get code to work for most of class but got it at end
    -   Produced:
        -   `RSBS_bam.list`
        -   `RSBS_poly_K2.admix.2.Q`
        -   `RSBS_poly_K2.log`
        -   `RSBS_poly_K2.admix.2.P`
        -   `RSBS_poly_K2.cov`
        -   Located in `~/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/PCA_ADMIX`
-   Also created an rmarkdown script called `PCA_Admix.Rmd` that will let us visualize the PCAngsd
    -   Script located in `/gpfs1/home/k/a/kaeller/projects/eco_genomics_2025/population_genomics/myscripts`

### 9/30/25:

-   Cont. from 9/25/25:
    -   Eigenvalue = explains the most variance it can given your data set
-   Created new modified `PCAngsd_allRS_selection.sh` script based on `PCAngsd_RSBS.sh`
    -   Basically, running same thing except we are excluding the black spruce populations-- we want to see if we can see gene flow after speciation using the PCA based on that

### HW1 Notes:

## Option 2: Testing for additional genetic structure and ancestry at higher levels of K

-   Created a copy of `PCAngsd_RSBS.sh` called `HW1_PCAngsd_RSBS.sh`, located in myscripts
-   Created a copy of `PCA_Admix.Rmd` called `HW1_PCA_Admix.Rmd`, located in mydocs
-   In `HW1_PCAngsd_RSBS.sh`: modified such that now K runs through a loop from 2-5, doing separate pcangsd for each.
-   Additionally, modified the output path such that it now outputs to a new folder, `HW1_PCA_ADMIX`.
- Could not figure out a good method to loop through creating figures, so did each level of admix figures individually.
- Also could not figure out if there was a way to ensure, or even check, that the colors assigned to admixture ancestry were consistent the whole time-- curious about this for future. Basically went through by trial and error.
- Also, it seemed that some of the admix plots 'flipped' vertically relative to themselves depending on the change of K.
