#!/bin/bash
# busco.sh
set -e

SPECIES=$1
source config.sh

if [ "$BUSCO" != "Yes" ]; then exit 0; fi

source ~/Tools/miniconda3/etc/profile.d/conda.sh
conda activate busco

for LINEAGE in fungi basidiomycota tremellomycetes; do
  busco -i "$PROTEOME_DIR/${SPECIES}.faa" \
        -l $LINEAGE \
        --out_path "$BUSCO_DIR/$LINEAGE/" \
        -o "${SPECIES}_${LINEAGE}" -m prot -c 10 \
        --download_path "$HOME/Tools/miniconda3/envs/busco/busco_downloads" -f
done