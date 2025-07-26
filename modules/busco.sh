#!/bin/bash
# busco.sh
set -e


# Allow standalone execution
if [ -z "$1" ]; then
  echo "Usage: $0 <species_name>"
  exit 1
fi


GENOME_ID=$1
source config.sh

source ~/Tools/miniconda3/etc/profile.d/conda.sh
conda activate "$BUSCO_ENV"

for LINEAGE in $LINEAGES; do
  busco -i "$PROTEOME_DIR/${GENOME_ID}.faa" \
        -l $LINEAGE \
        --out_path "$BUSCO_DIR/$LINEAGE/" \
        -o "${GENOME_ID}_${LINEAGE}" -m prot -c 10 \
        --download_path "$HOME/Tools/miniconda3/envs/busco/busco_downloads" -f
done

else 
  exit 0
fi
