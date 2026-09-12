#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

OUTPUT_DIR="$PROJECT_ROOT/02_data/05_heightmap_sor_filter"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Directory '$OUTPUT_DIR' does not exist."
    exit 1
fi

shopt -s nullglob
las_files=("$OUTPUT_DIR"/*.las)

if [ ${#las_files[@]} -eq 0 ]; then
    echo "No *.las files found in '$OUTPUT_DIR'."
    exit 1
fi

for las_file in "${las_files[@]}"; do

    filename=$(basename "$las_file")
    
    prefix="${filename%%_SOR_*}"

    output_file="$OUTPUT_DIR/${prefix}_SOR.laz"
    base="${prefix}_SOR"

    if [ -f "$output_file" ]; then
        echo "Skipping: ${base}.laz already exists."
        continue
    fi

    echo "Converting: ${filename}"
    echo "        To: ${base}.laz"

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

done

echo "------------------------------------------------"
echo "Finished: Converting .las to .laz"
echo "Directory: $OUTPUT_DIR"
