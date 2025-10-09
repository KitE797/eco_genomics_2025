#!/bin/sh
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=1:00:00 
#SBATCH --job-name=Salmon_mapping
#SBATCH --output=/users/k/a/kaeller/projects/eco_genomics_2025/transcriptomics/mylogs/%x_%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kaeller@uvm.edu



module purge

module load gcc/13.3.0-xp3epyt salmon/1.10.2-uhrt76c

salmon --version

# Echo some info
echo "Starting Salmon quantification at: `date`"
echo "Running on node: `hostname`"

MYSAMP="T4"

# Paths
READ_DIR=/gpfs1/cl/ecogen/pbio6800/Transcriptomics/cleandata
INDEX_DIR=/gpfs1/cl/ecogen/pbio6800/Transcriptomics/reference/salmon_index
OUT_DIR=/gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant

cd $READ_DIR

# Loop over all samples
for read1 in ${MYSAMP}*_R1_*.fastq.gz; do

    sample=$(basename "$read1" | sed -E 's/_R1_.*\.fastq\.gz//')
    
    echo "Starting sample ${sample}"

    read2=${READ_DIR}/${sample}_R2_$(basename "$read1" | sed -E 's/.*_R1_//')

    # Ensure files exist
    if [[ ! -f "$read1" || ! -f "$read2" ]]; then
        echo "WARNING: Missing read files for ${sample}, skipping."
        continue
    fi

    # Make sample-specific output folder
    mkdir -p ${OUT_DIR}/${sample}

    # Run Salmon quantification
    salmon quant -i $INDEX_DIR \
                 -l A \
                 -1 $read1 \
                 -2 $read2 \
                 -p 8 \
                 --softclip \
                 --seqBias \
                 --gcBias \
                 -o ${OUT_DIR}/${sample}

    echo "Sample ${sample} done"
done

echo "Salmon quantification completed at: `date`"