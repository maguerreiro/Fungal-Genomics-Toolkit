#!/bin/bash
# Module: Funannotate gene prediction
# Usage: bash funannotate.sh <species_name>
# Logs to: logs/<species>_funannotate.log

source config.sh
GENOME_ID="$1"

source ~/Tools/miniconda3/etc/profile.d/conda.sh
conda activate "$FUNANNOTATE_ENV"

mkdir -p "$FUNANNOTATE_DIR/$GENOME_ID"

# Example clean, sort, and predict steps (adjust as needed)
funannotate clean -i "$GENOMES_DIR/$GENOME_ID.fna" -o "$FUNANNOTATE_DIR/$GENOME_ID/cleaned"
funannotate sort -i "$FUNANNOTATE_DIR/$GENOME_ID/cleaned" -b contig -o "$FUNANNOTATE_DIR/$GENOME_ID/sorted"
funannotate mask -i "$FUNANNOTATE_DIR/$GENOME_ID/sorted" --cpus 4 -o "$FUNANNOTATE_DIR/$GENOME_ID/masked"
funannotate predict -i "$FUNANNOTATE_DIR/$GENOME_ID/masked" -o "$FUNANNOTATE_DIR/$GENOME_ID/output" --species "$GENOME_ID" --augustus_species "$funannotate_species" --cpus 4 --force

echo "Funannotate completed for $GENOME_ID"
