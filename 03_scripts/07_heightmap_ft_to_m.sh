#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_ground"
OUTPUT_DIR="$PROJECT_ROOT/02_data/07_heightmap_ft_to_m"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

for laz_file in "$INPUT_DIR"/*.laz; do
    [ -e "$laz_file" ] || {
        echo "No .laz files found in $INPUT_DIR."
        exit 1
    }

    filename=$(basename "$laz_file")
    [[ "$filename" == *_METERS.laz ]] && continue

    base=$(basename "$laz_file" .laz)
    echo "Processing: ${base}"
    # Convert X, Y, and Z coordinates from survey feet to meters.
    cat <<EOF | pdal pipeline --stdin --stream
{
    "pipeline": [
        {
            "type": "readers.las",
            "filename": "${laz_file}"
        },
        {
            "type": "filters.transformation",
            "matrix": "0.304800609601219 0 0 0 0 0.304800609601219 0 0 0 0 0.304800609601219 0 0 0 0 1"
        },
        {
            "type": "writers.las",
            "compression": "laszip",
            "filename": "${OUTPUT_DIR}/${base}_METERS.laz"
        }
    ]
}
EOF

    echo "Finished: ${base}_METERS.laz"
done

echo "------------------------------------------------"
echo "Finished: Scaling From Feet to Meters"
echo "Output: $OUTPUT_DIR"
