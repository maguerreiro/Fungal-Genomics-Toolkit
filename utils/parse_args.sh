#!/bin/bash
# parse_args.sh - argument parsing function

# Initialize variables
SELECTED_MODULES=()
SELECTED_GENOME=()
GENOMES_FILE=""
SHOW_HELP=0
CHECK=0
CHECK-FULL=0

declare -A MODULES_MAP


print_help() {
  cat << EOF
Usage: $0 [options] [genome ...]

Options:
  -m --modules      Comma-separated list of modules to run (overrides config toggles).
  -g --genome       Comma-separated list of genomes without extension to run (overrides GENOME_ID on config).
  -f --file         Path to genomes.txt file (overrides -s and GENOME_ID on config).
  --check           Checks all inputs and modules.
  --check-full      Checks all inputs and modules. Provides detailed output.
  --list-modules    List of available modules.
  -h --help         Show this help message and exit.

If no --file or --genome is provided, the default GENOME_ID from config.sh is used.
If no genome is given anywhere, will try to read genomes from 'genomes.txt' in current directory.

Examples:
  $0 -m busco,funannotate -s cryptococcus,another_genome
  $0 -f my_genomes.txt
  $0 cryptococcus
EOF
}


ALL_MODULES=(funannotate busco signalp6)

print_modules() {
  cat << EOF

Available modules:

  funannotate     Gene prediction.
  busco           Genome completeness.
  signalp6        Signal peptide prediction.

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

    --check)
      CHECK=1
      shift
      ;;

    --check-full)
      CHECK-FULL=1
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



