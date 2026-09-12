#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/08_heightmap_scale_50"
OUTPUT_DIR="$PROJECT_ROOT/02_data/09a_heightmap_merge_laz"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
laz_files=("$INPUT_DIR"/*.laz)

if [ ${#laz_files[@]} -eq 0 ]; then
    echo "No .laz files found in $INPUT_DIR."
    exit 1
fi

echo "Processing ${#laz_files[@]} LAZ files..."

pdal merge "${laz_files[@]}" "$OUTPUT_DIR/heightmap_MERGED.laz"

echo "Finished: heightmap_MERGED.laz"
echo "------------------------------------------------"
echo "Finished: Merging Point Cloud"
echo "Output: $OUTPUT_DIR"
