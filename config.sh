#!/bin/bash
# config.sh

# ============================
# CONFIGURATION FILE
# ============================

n_cpus=28

# Leave empty to use -s or get a list from genomes.txt
GENOME_ID=

# Old parameter. Keep for now, or it will break.
DATASET=funannotate

# If -m is not specified, toggles in config.sh are used

# Toggles (Yes/No)
funannotate=Yes
busco=Yes
signalp6=No

# Species model names
Augustus_species="cryptococcus"
funannotate_species="cryptococcus"

# BUSCO lineages separated by a space
LINEAGES="fungi basidiomycota tremellomycetes"

# Paths
GENOMES_DIR="genomes"
PROTEOME_DIR=
LOG_DIR="./logs"

FUNANNOTATE_DIR="./results/funannotate"
BUSCO_DIR="./results/busco"
SIGNALP6_DIR="./results/signalp6"

# Tools
## Path to tools installed locally
AUGUSTUS=
FUNANNOTATE=
EGGNOG=
BUSCO=
SIGNALP6=
seqkit=

## Conda environment names for tools installed as conda environments
BUSCO_ENV="busco"
FUNANNOTATE_ENV="funannotate"