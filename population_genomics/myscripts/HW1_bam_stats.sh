#!/bin/bash


#---------  Slurm preamble, defines the job with #SBATCH statements

# Give your job a name that's meaningful to you, but keep it short
#SBATCH --job-name=bash_stats

# Name the output file: Re-direct the log file to your home directory
# The first part of the name (%x) will be whatever you name your job 
#SBATCH --output=/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics/mylogs/%x_%j.out

# Which partition to use: options include short (<3 hrs), general (<48 hrs), or week
#SBATCH --partition=general

# Specify when Slurm should send you e-mail.  You may choose from
# BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kaeller@uvm.edu

# Run on a single node with four cpus/cores and 8 GB memory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00

#---------  End Slurm preamble, job commands now follow


# Below here, give you bash script with your list of commands


### Add your comments/annotations here

# Remove all software modules and load all and only those needed

module purge

module load gcc samtools


# Path to the population_genomics folder in your repo:

MYREPO="/users/k/a/kaeller/projects/eco_genomics_2025/population_genomics"


# Directory where the mapping alignment files live:

INPUT="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams"


### Challenge ###

# For each section below, I've left blank (XXXX) a few of the places where variables names should go. 
# You'll need to replace with the correct variable at each step in your loops
# This will require you to think carefully about which variable name shouLd go in which placeholder!  
# Think: where do you want to use input paths vs. sample (pop) names? Where do you want to direct your results to?


### Make the header for your pop's stats file

echo -e "SampleID Num_reads Num_R1 Num_R2 Num_Paired Num_MateMapped Num_Singletons Num_MateMappedDiffChr Coverage_depth" \
  >${MYREPO}/myresults/all.stats.txt


### Calculate stats on bwa alignments

for FILE in ${INPUT}/*.sorted.rmdup.bam  # loop through each of your pop's processed bam files in the input directory
do
	F=${FILE/.sorted.rmdup.bam/} # isolate the sample ID name by stripping off the file extension
	NAME=`basename ${F}`  # further isolate the sample ID name by stripping off the path location at the beginning
	echo ${NAME} >> ${MYREPO}/myresults/all.names  # print the sample ID names to a file
	samtools flagstat ${FILE} | awk 'NR>=9&&NR<=15 {print $1}' | column -x  # calculate the mapping stats
done >> ${MYREPO}/myresults/all.flagstats  # append the stats as a new line to an output file that increases with each iteration of the loop


### Calculate mean sequencing depth of coverage


for FILE2 in ${INPUT}/*.sorted.rmdup.bam
do
	samtools depth ${FILE2} | awk '{sum+=$3} END {print sum/NR}'  # calculate the per-site read depth, sum across sites, and calc the mean by dividing by the total # sites
done >> ${MYREPO}/myresults/all.coverage # append the mean depth as a new line to an output file that increases with each iteration of the loop


### Put all the stats together into 1 file:

paste ${MYREPO}/myresults/all.names \
	${MYREPO}/myresults/all.flagstats \
	${MYREPO}/myresults/all.coverage \
	>>${MYREPO}/myresults/all.stats.txt # stitch ('paste') the files together column-wise
