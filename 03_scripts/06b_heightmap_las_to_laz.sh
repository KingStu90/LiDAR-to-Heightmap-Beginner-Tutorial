#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

GROUND_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_ground"
OFFGROUND_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_offground"

convert_and_rename_las_to_laz() {
    INPUT_DIR="$1"
    SUFFIX_TYPE="$2"

    if [ ! -d "$INPUT_DIR" ]; then
        echo "Error: Directory '$INPUT_DIR' does not exist."
        exit 1
    fi

    shopt -s nullglob
    
    if [ "$SUFFIX_TYPE" = "GROUND" ]; then
        las_files=("$INPUT_DIR"/*_ground_points_*.las)
        target_suffix="_GROUND.laz"
    else
        las_files=("$INPUT_DIR"/*_offground_points_*.las)
        target_suffix="_OFFGROUND.laz"
    fi

    if [ ${#las_files[@]} -eq 0 ]; then
        echo "No matching .las files found in '$INPUT_DIR'."
        return
    fi

    for las_file in "${las_files[@]}"; do

        filename=$(basename "$las_file")
        
        if [ "$SUFFIX_TYPE" = "GROUND" ]; then
            prefix="${filename%%_ground_points_*}"
        else
            prefix="${filename%%_offground_points_*}"
        fi

        output_file="$INPUT_DIR/${prefix}${target_suffix}"
        base="${prefix}${target_suffix%.laz}"

        if [ -f "$output_file" ]; then
            echo "Skipping: ${base}.laz already exists."
            continue
        fi

        echo "Converting & Renaming: ${filename}"
        echo "                   To: ${base}.laz"

        cat <<EOF | pdal pipeline --stdin --stream
{
    "pipeline": [
        {
            "type": "readers.las",
            "filename": "${las_file}"
        },
        {
            "type": "writers.las",
            "compression": "laszip",
            "filename": "${output_file}"
        }
    ]
}
EOF

        if [ ! -f "$output_file" ]; then
            echo "ERROR: Expected output was not created:"
            echo "$output_file"
            exit 1
        fi

        echo "Finished: Created ${base}.laz (kept original .las)"

    done
}

echo "------------------------------------------------"
echo "Finished: Converting GROUND .las to .laz"
echo "------------------------------------------------"

convert_and_rename_las_to_laz "$GROUND_DIR" "GROUND"

echo "------------------------------------------------"
echo "Finished: Converting OFFGROUND .las to .laz"
echo "------------------------------------------------"

convert_and_rename_las_to_laz "$OFFGROUND_DIR" "OFFGROUND"

echo "------------------------------------------------"
echo "Finished: Converting .las to .laz"
echo "Ground output: $GROUND_DIR"
echo "Off-ground output: $OFFGROUND_DIR"
