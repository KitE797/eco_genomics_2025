#!/bin/bash


#---------  Slurm preamble, defines the job with #SBATCH statements

# Give your job a name that's meaningful to you, but keep it short
#SBATCH --job-name=RSBS_poly

# Name the output file: Re-direct the log file to your home directory
# The first part of the name (%x) will be whatever you name your job 
#SBATCH --output=/users/s/r/srkeller/courses/Ecological_Genomics_25/population_genomics/mylogs/%x_%j.out

# Which partition to use: options include short (<3 hrs), general (<48 hrs), or week
#SBATCH --partition=general

# Specify when Slurm should send you e-mail.  You may choose from
# BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srkeller@uvm.edu

# Run on a single node with four cpus/cores and 8 GB memory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00

#---------  End Slurm preamble, job commands now follow

module load gcc angsd

# Below here, give you bash script with your list of commands


# pcANGSD model:

REF="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome/Pmariana/Pmariana1.0-genome_reduced.fa"

SUFFIX="RSBS_poly"

INPUT="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams"

OUT="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ANGSD"

# Make a list of all the sorted and PCR dup removed bam files:

ls ${INPUT}/*sorted.rmdup.bam >${OUT}/RSBS_bam.list


# Now run ANGSD to estimate the GL's:

angsd -b ${OUT}/RSBS_bam.list \
-ref ${REF} \
-anc ${REF} \
-out ${OUT}/${SUFFIX} \
-nThreads 20 \
-remove_bads 1 \
-C 50 \
-baq 1 \
-minMapQ 20 \
-minQ 20 \
-GL 2 \
-doSaf 1 \
-doCounts 1 \
-minInd 57 \
-setMinDepthInd 1 \
-setMaxDepthInd 40 \
-setMinDepth 10 \
-skipTriallelic 1 \
-doMajorMinor 4 \
-doMaf 2 \
-minMaf 0.01 \
-SNP_pval 1e-6 \
-doGLF 2

# refer to the ANGSD user's manual for option definitions
# starting with the 'minInd' flag and up to the 'SNP_pval 1e-6' flag are the options for filtering the data for read depth and SNP presence
# the 'doGLF 2' option here saves the genotype likelihoods to a beagle file that can be used for future pcANGSD runs
