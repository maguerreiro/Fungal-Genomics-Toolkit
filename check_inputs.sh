#!/bin/bash
# check_inputs.sh - input and module validation function

source parse_args.sh

check_inputs() {
  local all_ok=1
  local found_genomes=()
  local missing_genomes=()
  local found_modules=()
  local missing_modules=()

  echo ""
  echo "Checking genome files in: $GENOME_DIR"
  for genome in "${GENOMES[@]}"; do
    genome_path="${GENOME_DIR}/${genome}.fna"  # Adjust extension if needed
    if [ -f "$genome_path" ]; then
      echo "[OK] $genome_path"
      found_genomes+=("$genome")
    else
      echo "[MISSING] $genome_path"
      missing_genomes+=("$genome")
      all_ok=0
    fi
  done

  echo ""
  echo "Checking module scripts in ./modules/"
  for mod in "${!MODULES_MAP[@]}"; do
    if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
      mod_path="./modules/${mod}.sh"
      if [ -x "$mod_path" ]; then
        echo "[OK] $mod_path"
        found_modules+=("$mod")
      else
        echo "[MISSING or NOT EXECUTABLE] $mod_path"
        missing_modules+=("$mod")
        all_ok=0
      fi
    fi
  done

  echo ""
  echo "===== SUMMARY ====="
  echo "Selected modules:"
  for mod in "${!MODULES_MAP[@]}"; do
    if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
      echo "  ${mod}.sh"
    fi
  done

  echo ""
  echo "Selected genomes:"
  for genome in "${GENOMES[@]}"; do
    echo "  $genome"
  done
    echo "==================="

  echo ""
  echo "Found genome files:"
  for g in "${found_genomes[@]}"; do
    echo "  $g"
  done

  echo ""
  echo "Missing genome files:"
  for g in "${missing_genomes[@]}"; do
    echo "  $g"
  done

  echo ""
  echo "Found modules:"
  for m in "${found_modules[@]}"; do
    echo "  ${m}.sh"
  done

  echo ""
  echo "Missing or non-executable modules:"
  for m in "${missing_modules[@]}"; do
    echo "  ${m}.sh"
  done

 echo ""
  if [ "$all_ok" -ne 1 ]; then
    echo "ERROR: One or more required files or scripts are missing or not executable."
    exit 1
  fi

  exit 0
}





# #!/bin/bash
# # check_inputs.sh - input and module validation function

# check_inputs() {
#   local all_ok=1
#   local found_genomes=()
#   local missing_genomes=()
#   local found_modules=()
#   local missing_modules=()

#   echo ""
#   echo "Checking genome files in: $GENOME_DIR"
#   for genome in "${GENOMES[@]}"; do
#     genome_file="${genome##*/}"         # Strip path (if any)
#     base_name="${genome_file%.*}"       # Remove extension
#     genome_path="${GENOME_DIR}/${base_name}.fna"  # Expected extension .fna

#     if [ -f "$genome_path" ]; then
#       echo "[OK] $genome_path"
#       found_genomes+=("$base_name")
#     else
#       echo "[MISSING] $genome_path"
#       missing_genomes+=("$base_name")
#       all_ok=0
#     fi
#   done

#   echo ""
#   echo "Checking module scripts in ./modules/"
#   for mod in "${!MODULES_MAP[@]}"; do
#     if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
#       mod_path="./modules/${mod}.sh"
#       if [ -x "$mod_path" ]; then
#         echo "[OK] $mod_path"
#         found_modules+=("$mod")
#       else
#         echo "[MISSING or NOT EXECUTABLE] $mod_path"
#         missing_modules+=("$mod")
#         all_ok=0
#       fi
#     fi
#   done

#   echo ""
#   echo "===== SUMMARY ====="
#   echo "Selected modules:"
#   for mod in "${!MODULES_MAP[@]}"; do
#     if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
#       echo "  ${mod}.sh"
#     fi
#   done

#   echo ""
#   echo "Selected genomes:"
#   for genome in "${GENOMES[@]}"; do
#     echo "  $genome"
#   done
#   echo "==================="

#   echo ""
#   echo "Found genome files:"
#   for g in "${found_genomes[@]}"; do
#     echo "  $g"
#   done

#   echo ""
#   echo "Missing genome files:"
#   for g in "${missing_genomes[@]}"; do
#     echo "  $g"
#   done

#   echo ""
#   echo "Found modules:"
#   for m in "${found_modules[@]}"; do
#     echo "  ${m}.sh"
#   done

#   echo ""
#   echo "Missing or non-executable modules:"
#   for m in "${missing_modules[@]}"; do
#     echo "  ${m}.sh"
#   done

#   echo ""
#   if [ "$all_ok" -ne 1 ]; then
#     echo "ERROR: One or more required files or scripts are missing or not executable."
#     exit 1
#   fi

#   exit 0
# }
