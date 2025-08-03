#!/bin/bash
# setup.sh - setup environment, check permissions, create folders

setup_environment() {

    # Ensure module scripts are executable
    for script in ./modules/*.sh; do
    if [ ! -x "$script" ]; then
        chmod +x "$script"
    fi
    done


# Create logs folder if missing
mkdir -p "$LOG_DIR"
echo "Module run summary:" > "$LOG_DIR/summary.txt"


}
