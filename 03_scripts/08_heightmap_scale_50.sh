#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/07_heightmap_ft_to_m"

if [ ! -d "$INPUT_DIR" ]; then
    INPUT_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_ground"
fi

OUTPUT_DIR="$PROJECT_ROOT/02_data/08_heightmap_scale_50"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Neither '07_heightmap_ft_to_m' nor '06_heightmap_csf_ground' exists."
    exit 1
fi

echo "Input: $INPUT_DIR"

mkdir -p "$OUTPUT_DIR"

for laz_file in "$INPUT_DIR"/*.laz; do
    [ -e "$laz_file" ] || {
        echo "No .laz files found in $INPUT_DIR."
        exit 1
    }

    filename=$(basename "$laz_file")
    [[ "$filename" == *_SCALE50.laz ]] && continue

    base="${filename%.laz}"

    echo "Processing: $base"
    # Scale X, Y, and Z coordinates to 50%. 
    cat <<EOF | pdal pipeline --stdin --stream
{
    "pipeline": [
        {
            "type": "readers.las",
            "filename": "$laz_file"
        },
        {
            "type": "filters.transformation",
            "matrix": "0.5 0 0 0 0 0.5 0 0 0 0 0.5 0 0 0 0 1"
        },
        {
            "type": "writers.las",
            "compression": "laszip",
            "filename": "${OUTPUT_DIR}/${base}_SCALE50.laz"
        }
    ]
}
EOF

    echo "Finished: ${base}_SCALE50.laz"
done

echo "------------------------------------------------"
echo "Finished: Scale to 50%"
echo "Output: $OUTPUT_DIR"
