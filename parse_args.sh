#!/bin/bash
# parse_args.sh - argument parsing function

parse_args() {
  # Initialize variables
  SELECTED_MODULES=()
  SELECTED_GENOME=()
  GENOMES_FILE=""
  CHECK=0
  DRY_RUN=0

  declare -A MODULES_MAP

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

    --check)
      CHECK=1
      shift
      ;;

    --list-modules)
      print_modules
      exit 0
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

  # Use config toggles if no modules specified
  if [ ${#MODULES_MAP[@]} -eq 0 ]; then
    for mod in "${ALL_MODULES[@]}"; do
      toggle="${!mod}"
      if [[ "${toggle,,}" == "yes" || "${toggle,,}" == "y" ]]; then
        MODULES_MAP["$mod"]="Yes"
      fi
    done
  fi

  if [ ${#MODULES_MAP[@]} -eq 0 ]; then
    echo "No modules selected. Exiting."
    exit 1
  fi
}
