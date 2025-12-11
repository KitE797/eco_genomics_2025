-   Started working with repeatmasker in beginning of class, this was abandoned

-   Low coverage whole genome sequencing: scripts located in `/gpfs1/cl/ecogen/pbio6800/GroupProjects/tripods/scripts/LCGWS`

    -   Created an array to map the fasta files to the reference genome using bwa-mem2

        -   Originally just a regular sbatch (`LCWGS_mapping.sh`), then switched to array (`LCWGS_mapping_array.sh`)

        -   Input fasta files located in `/gpfs1/cl/ecogen/pbio6800/GroupProjects/tripods/data/LCWGS_cleanedreads`

        -   Output to `/gpfs1/cl/ecogen/pbio6800/GroupProjects/tripods/data/LCWGS_mappedreads`

    -   Tried to index with bwa-mem2 as well, worked for mapping but did not work for genotype likelihoods

        -   Created separate sh file for this in order to test without rerunning mapping (\``LCWGS_indexing.sh`)

    -   Processed sam files into bam files using sambamba

        -   `LCWGS_process_bam.sh` and `LCWGS_bam_stats.sh`

    -   Created genotype likelihoods for each population (LAT1, SEA1, SEA2).

        -   `LCWGS_ANGSD_LAT1.sh` `LCWGS_ANGSD_SEA1.sh` `LCWGS_ANGSD_SEA2.sh`

        -   In these files, populations were separated and bam.lists created. Output to `/gpfs1/cl/ecogen/pbio6800/GroupProjects/tripods/data/ANGSD`

    -   Used PCAngsd to generate beagle files.

        -   `LCWGS_PCAngsd_LAT1.sh` `LCWGS_PCAngsd_SEA1.sh` `LCWGS_PCAngsd_SEA2.sh`

    -   Created r markdown to look at selection signatures:

        -   `selection.Rmd` , located in `/gpfs1/cl/ecogen/pbio6800/GroupProjects/tripods/docs/`

        -   Could not get significance in LAT1 and SEA1, so focused on SEA2
