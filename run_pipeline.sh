#!/bin/bash
# run_pipeline.sh
set -e

source config.sh

if [ -n "$1" ]; then
  GENOMES=("$@")  # Pass genomes as arguments
else
  mapfile -t GENOMES < genomes.txt  # Or get genomes.txt from the list
fi

for SPECIES in "${GENOMES[@]}"; do
  export SPECIES
  echo "=== Processing $SPECIES ==="
  
  ./modules/funannotate.sh "$SPECIES"
  ./modules/busco.sh "$SPECIES"
  ./modules/signalp.sh "$SPECIES"

done
