#!/bin/bash   
#---------  Slurm preamble, defines the job with #SBATCH statements

# Give your job a name that's meaningful to you, but keep it short
#SBATCH --job-name=fastp

# Name the output file: Re-direct the log file to your home directory
# The first part of the name (%x) will be whatever you name your job 
#SBATCH --output=/users/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/mylogs/%x_%j.out

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
#SBATCH --mem=64G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00


# Below here, give you bash script with your list of commands

# This script loops through a set of files defined by MYSAMP, matching left and right reads
# and cleans the raw data using fastp according to parameters set below

# Next, let's load our required modules:
module purge
module load gcc fastp

# Define the path to the transcriptomics folder in your Github repo.
MYREPO="/users/k/a/kaeller/projects/eco_genomics_2025"

# make a new directory within myresults/ to hold the fastp QC reports
mkdir ${MYREPO}/transcriptomics/myresults/fastp_reports

# cd to the location (path) to the fastq data:

cd /gpfs1/cl/ecogen/pbio6800/Transcriptomics/RawData

# Define the sample code to anlayze
# Be sure to replace with your 2-digit sample code

MYSAMP="T4"

# for each file that has "MYSAMP" and "_1.fq.gz" (read 1) in the name
# the wildcard here * allows for the different reps to be captured in the list
# start a loop with this file as the input:

for READ1 in ${MYSAMP}*_R1*.gz
do

# the partner to this file (read 2) can be found by replacing the _1.fq.gz with _2.fq.gz
# second part of the input for PE reads

READ2=${READ1/_R1*.gz/_R2*.gz}

# make the output file names: print the fastq name, replace _# with _#_clean

NAME1=$(echo $READ1 | sed "s/_R1/_R1_cleanKE/g")
NAME2=$(echo $READ2 | sed "s/_R2/_R2_cleanKE/g")

# print the input and output to screen 

echo $READ1 $READ2
echo $NAME1 $NAME2

# call fastp
fastp -i ${READ1} -I ${READ2} \
-o /gpfs1/cl/ecogen/pbio6800/Transcriptomics/cleandata/${NAME1} \
-O /gpfs1/cl/ecogen/pbio6800/Transcriptomics/cleandata/${NAME2} \
--detect_adapter_for_pe \
--trim_poly_g \
--thread 4 \
--cut_right \
--cut_window_size 6 \
--qualified_quality_phred 20 \
--length_required 35 \
--html ${MYREPO}/transcriptomics/myresults/fastp_reports/${NAME1}.html

done
