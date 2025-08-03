#!/bin/bash
# setup.sh - setup environment, check permissions, create folders

setup_environment() {
  echo "Setting up environment..."

  # Make sure modules scripts are executable if they exist
  for mod_script in ./modules/*.sh; do
    if [[ -f "$mod_script" && ! -x "$mod_script" ]]; then
      echo "Making $mod_script executable"
      chmod +x "$mod_script"
    fi
  done

  # Create logs and results directories if missing
  mkdir -p "$LOG_DIR"
  mkdir -p "$FUNANNOTATE_DIR" "$BUSCO_DIR" "$SIGNALP6_DIR"

  echo "Setup complete."
}
