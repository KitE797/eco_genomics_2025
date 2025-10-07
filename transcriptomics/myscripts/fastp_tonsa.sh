#!/bin/bash   

# This script loops through a set of files defined by MYSAMP, matching left and right reads
# and cleans the raw data using fastp according to parameters set below

# Next, let's load our required modules:
module purge
module load gcc fastp

# Define the path to the population_genomics folder in your Github repo.
MYREPO="/users/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/"

# make a new directory within myresults/ to hold the fastp QC reports
mkdir ${MYREPO}/myresults/fastp_reports

# cd to the location (path) to the fastq data:

cd /gpfs1/cl/ecogen/pbio6800/Transcriptomics/RawData

# Define the sample code to anlayze
# Be sure to replace with your 4-digit sample code

MYSAMP="T4R"

# for each file that has "MYSAMP" and "_1.fq.gz" (read 1) in the name
# the wildcard here * allows for the different reps to be captured in the list
# start a loop with this file as the input:

for READ1 in ${MYSAMP}*_R1*.gz
do

# the partner to this file (read 2) can be found by replacing the _1.fq.gz with _2.fq.gz
# second part of the input for PE reads

READ2=${READ1/_R1*.gz/_R2*.gz}

# make the output file names: print the fastq name, replace _# with _#_clean. Also adding my initials to read name

NAME1=$(echo $READ1 | sed "s/_R1/_R1_clean_KE/g")
NAME2=$(echo $READ2 | sed "s/_R2/_R2_clean_KE/g")

# print the input and output to screen 

echo $READ1 $READ2
echo $NAME1 $NAME2

# call fastp
fastp -i ${READ1} -I ${READ2} -o /gpfs1/cl/ecogen/pbio6800/Transcriptomics/cleandata/${NAME1} -O /gpfs1/cl/ecogen/pbio6800/Transcriptomics/cleandata/${NAME2} \
--detect_adapter_for_pe \
--trim_poly_g \
--thread 4 \
--cut_right \
--cut_window_size 6 \
--qualified_quality_phred 20 \
--length_required 35 \
--html ~/myresults/fastqc/${NAME1}.html

done
