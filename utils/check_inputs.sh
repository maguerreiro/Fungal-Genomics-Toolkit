#!/bin/bash
# check_inputs.sh - input and module validation function

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


check_inputs() {
  local all_genomes_ok=1
  local all_modules_ok=1
  local found_genomes=()
  local missing_genomes=()
  local found_modules=()
  local missing_modules=()

#  echo ""
#  echo "Checking genome files in: $GENOME_DIR"
  for genome in "${GENOMES[@]}"; do
    genome_path="${GENOME_DIR}/${genome}.fna"  # Adjust extension if needed
    if [ -f "$genome_path" ]; then
#      echo "[OK] $genome_path"
      found_genomes+=("$genome")
    else
#      echo "[MISSING] $genome_path"
      missing_genomes+=("$genome")
      all_genomes_ok=0
    fi
  done

#  echo ""
#  echo "Checking module scripts in ./modules/"
  for mod in "${!MODULES_MAP[@]}"; do
    if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
      mod_path="./modules/${mod}.sh"
      if [ -x "$mod_path" ]; then
#        echo "[OK] $mod_path"
        found_modules+=("$mod")
      else
#        echo "[MISSING or NOT EXECUTABLE] $mod_path"
        missing_modules+=("$mod")
        all_modules_ok=0
      fi
    fi
  done

 echo ""
  if [ "$all_genomes_ok" -ne 1 ]; then
    echo "ERROR: One or more genomes are missing."
    echo "Missing genome files:"
      for g in "${missing_genomes[@]}"; do
    echo "  $g"
  done 
    exit 1
  fi

   echo ""
  if [ "$all_modules_ok" -ne 1 ]; then
    echo "ERROR: One or more scripts are missing or not executable."
    echo ""
    echo "Missing or non-executable modules:"
  for m in "${missing_modules[@]}"; do
    echo "  ${m}.sh"
  done
    echo ""
    exit 1
  fi


  if [ "$all_modules_ok" -eq 1  & "$all_genomes_ok" -eq 1]; then
    echo "All genomes and modules were found."
  fi
     echo ""
  exit 0
}



check_full_inputs() {
  local all_genomes_ok=1
  local all_modules_ok=1
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
      all_genomes_ok=0
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
        all_modules_ok=0
      fi
    fi
  done

  echo ""
  echo "===== SUMMARY ====="
  echo ""
  echo "----- MODULES -----"
  echo "Selected modules:"
  for mod in "${!MODULES_MAP[@]}"; do
    if [ "${MODULES_MAP[$mod]}" == "Yes" ]; then
      echo "  ${mod}.sh"
    fi
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
  echo "----- GENOMES -----"
  echo "Selected genomes:"
  for genome in "${GENOMES[@]}"; do
    echo "  $genome"
  done
 
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
    echo "==================="



  echo ""
  if [ "$all_genomes_ok" -ne 1 ]; then
    echo "ERROR: One or more genomes are missing."
    echo "Missing genome files:"
      for g in "${missing_genomes[@]}"; do
    echo "  $g"
  done 
    echo ""
    exit 1
  fi

   echo ""
  if [ "$all_modules_ok" -ne 1 ]; then
    echo "ERROR: One or more scripts are missing or not executable."
      echo "Missing or non-executable modules:"
  for m in "${missing_modules[@]}"; do
    echo "  ${m}.sh"
  done
    echo ""
    exit 1
  fi

  exit 0
}
