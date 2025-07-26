#!/bin/bash
# run_pipeline.sh
set -e

source config.sh


# Initialize variables
SELECTED_MODULES=()
SELECTED_GENOME=()
GENOMES_FILE=""
SHOW_HELP=0


print_help() {
  cat << EOF
Usage: $0 [options] [genome ...]

Options:
  -m --modules    Comma-separated list of modules to run (overrides config toggles).
  -g --genome     Comma-separated list of genomes without extension to run (overrides GENOME_ID on config).
  -f --file       Path to genomes.txt file (overrides -s and GENOME_ID on config).
  -h --help       Show this help message and exit.

If no --file or --genome is provided, the default GENOME_ID from config.sh is used.
If no genome is given anywhere, will try to read genomes from 'genomes.txt' in current directory.

Examples:
  $0 -m busco,funannotate -s cryptococcus,another_genome
  $0 -f my_genomes.txt
  $0 cryptococcus
EOF
}


# Parse arguments


while [[ $# -gt 0 ]]; do
  case "$1" in

    -m|--modules)
    # Check for -m flag (comma-separated list of modules)
    # If not provided, runs according to toggles in config.sh
    # -m flag overrides toggles
      shift
      IFS=',' read -r -a SELECTED_MODULES <<< "$1"
      for mod in "${SELECTED_MODULES[@]}"; do
        mod_lower=$(echo "$mod" | tr '[:upper:]' '[:lower:]')
        MODULES_MAP[$mod_lower]="Yes"
      done
      shift
      ;;

    -g|--genome)
      shift
      IFS=',' read -r -a SELECTED_GENOME <<< "$1"
      shift
      ;;

    -f|--file)
      shift
      GENOMES_FILE="$1"
      shift
      ;;

    -h|--help)
      print_help
      exit 0
      ;;

    --) # end of options
      shift
      break
      ;;
      
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done


# Determine GENOMES
if [ -n "$GENOMES_FILE" ]; then
  if [ ! -f "$GENOMES_FILE" ]; then
    echo "Error: genomes file '$GENOMES_FILE' not found." >&2
    exit 1
  fi
  mapfile -t GENOMES < "$GENOMES_FILE"
elif [ ${#SELECTED_GENOME[@]} -gt 0 ]; then
  GENOMES=("${SELECTED_GENOME[@]}")
elif [ -n "$GENOME_ID" ]; then
  GENOMES=("$GENOME_ID")
elif [ $# -gt 0 ]; then
  GENOMES=("$@")
elif [ -f "genomes.txt" ]; then
  mapfile -t GENOMES < "genomes.txt"
else
  echo "Error: No genomes provided." >&2
  exit 1
fi


# Create logs folder if missing
mkdir -p "$LOG_DIR"


# Use config.sh toggles if -m not given
if [ ${#MODULES_MAP[@]} -eq 0 ]; then
  ALL_MODULES=("funannotate" "busco" "signalp6")
  for mod in "${ALL_MODULES[@]}"; do
    toggle="${!mod}"  # indirect expansion
    if [[ "${toggle,,}" == "yes" || "${toggle,,}" == "y" ]]; then
      MODULES_MAP["$mod"]="Yes"
    fi
  done
fi


# Run modules
for GENOME_ID in "${GENOMES[@]}"; do
  echo "=== Processing $GENOME_ID ==="
  for mod in "${!MODULES_MAP[@]}"; do
    if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
      echo ">> Running module: $mod for $GENOME_ID"
      ./modules/${mod}.sh "$GENOME_ID"  > "$LOG_DIR/${GENOME_ID}_${mod}.log" 2>&1
    fi
  done
done

