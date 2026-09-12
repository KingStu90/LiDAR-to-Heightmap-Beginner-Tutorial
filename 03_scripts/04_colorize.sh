#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/01_download"
OUTPUT_DIR="$PROJECT_ROOT/02_data/04_colorize"

TIF_FILE="$INPUT_DIR/MERGED_REPROJECT.tif"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

if [ ! -f "$TIF_FILE" ]; then
    echo "Error: Input file '$TIF_FILE' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
laz_files=("$INPUT_DIR"/*.laz)

if [ ${#laz_files[@]} -eq 0 ]; then
    echo "No .laz files found in '$INPUT_DIR'."
    exit 1
fi

for laz_file in "${laz_files[@]}"; do

    filename=$(basename "$laz_file")
    [[ "$filename" == *_COLOR.laz ]] && continue

    base=$(basename "$laz_file" .laz)
    echo "Colorizing: $base"

    cat <<EOF | pdal pipeline --stdin --stream
{
    "pipeline": [
        {
            "type": "readers.las",
            "filename": "${laz_file}"
        },
        {
            "type": "filters.colorization",
            "raster": "${TIF_FILE}"
        },
        {
            "type": "writers.las",
            "compression": "true",
            "minor_version": "4",
            "dataformat_id": "7",
            "filename": "${OUTPUT_DIR}/${base}_COLOR.laz"
        }
    ]
}
EOF

    echo "Finished: ${base}_COLOR.laz"
done

echo "------------------------------------------------"
echo "Finished: Colorizing Point Cloud"
echo "Output: $OUTPUT_DIR"
