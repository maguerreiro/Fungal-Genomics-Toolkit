#!/bin/bash
# Module: Funannotate gene prediction
# Usage: bash funannotate.sh <species_name>
# Logs to: logs/<species>_funannotate.log

source config.sh
GENOME_ID="$1"

source ~/Tools/miniconda3/etc/profile.d/conda.sh
conda activate "$FUNANNOTATE_ENV"

mkdir -p "$FUNANNOTATE_DIR/$GENOME_ID"
mkdir -p "$PROTEOME_DIR"
mkdir -p "$CDS_DIR"
mkdir -p "$PROT_IDS"

# The script sorts contigs by size, starting with shortest contigs it uses minimap2 to find contigs duplicated elsewhere, and then removes duplicated contigs.
# Minimum length of contig to keep. Default = 500
funannotate clean -i $GENOMES_DIR/$GENOME_ID.fna -o $FUNANNOTATE_DIR/$GENOME_ID.cleaned

# sorts the input contigs by size (longest->shortest) and then relabels the contigs with a simple name (e.g. scaffold_1). Augustus can have problems with some complicated contig names.
funannotate sort -i $FUNANNOTATE_DIR/$GENOME_ID.cleaned  \
                 -b contig  \
                 -o $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted

# Default is to run very simple repeat masking with tantan.
funannotate mask -i $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted  \
                 --cpus $n_cpus  \
                 -o $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted.masked

# Runs gene prediction pipeline
funannotate predict -i $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted.masked  \
                    -o $FUNANNOTATE_DIR/$GENOME_ID  \
                    --species $GENOME_ID   \
                    --cpus $n_cpus  \
                    --augustus_species $funannotate_species  \
                    --busco_seed_species $funannotate_species  \
                    --busco_db basidiomycota  \
                    --force  \
                    --no-progress

# Move files to folder
mv $FUNANNOTATE_DIR/$GENOME_ID.cleaned  \
   $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted  \
   $FUNANNOTATE_DIR/$GENOME_ID.cleaned.sorted.masked  \
   $FUNANNOTATE_DIR/$GENOME_ID/

# Change protein header, move file to proteome folder and renames extension to .faa
awk '/^>/{print ">'$GENOME_ID'|" ++i; next}{print}' < $FUNANNOTATE_DIR/$GENOME_ID/predict_results/$GENOME_ID.proteins.fa > $PROTEOME_DIR/Proteome_headers/$GENOME_ID.faa

# Change CDS header and move file to CDS folder
awk '/^>/{print ">'$GENOME_ID'|" ++i; next}{print}' < $FUNANNOTATE_DIR/$GENOME_ID/predict_results/$GENOME_ID.cds-transcripts.fa > $CDS_DIR/CDS_headers/$GENOME_ID.codingseq

# Protein IDs
cat $PROTEOME_DIR/Proteome_headers/$GENOME_ID.faa | grep ">" | sed 's/>//' > $PROT_IDS/$GENOME_ID'_proteinIDs.txt'




### NEEDS RECONFIG ###
# Sequence length
~/Tools/seqkit fx2tab --length --name $CDS_DIR/CDS_headers/$GENOME_ID.codingseq > ~/Trichosporonales_project/Data/$DATASET/CDS_length/$GENOME_ID.length
cat ~/Trichosporonales_project/Data/$DATASET/CDS_length/*.length > ~/Trichosporonales_project/Data/$DATASET/CDS_length/all.length
######################





echo "Funannotate completed for $GENOME_ID"
