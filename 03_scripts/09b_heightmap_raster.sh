#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/09a_heightmap_merge_laz"
OUTPUT_DIR="$PROJECT_ROOT/02_data/09b_heightmap_raster"

if [ ! -d "$INPUT_DIR" ]; then
    INPUT_DIR="$PROJECT_ROOT/02_data/08_heightmap_scale_50"
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Neither input directory exists."
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
    base="${filename%.laz}"

    output_file="$OUTPUT_DIR/${base}.tif"

    # Skip if the final raster already exists in OUTPUT_DIR
    if [ -f "$output_file" ]; then
        echo "Skipping: ${base}.tif already exists in OUTPUT_DIR."
        continue
    fi

    echo "Processing: ${filename}"

    CloudCompare \
        -SILENT \
        -O -GLOBAL_SHIFT AUTO "$laz_file" \
        -RASTERIZE \
            -GRID_STEP 1.0 \
            -VERT_DIR 2 \
            -PROJ AVG \
            -EMPTY_FILL KRIGING \
            -OUTPUT_RASTER_Z

    status=$?

    if [ $status -ne 0 ]; then
        echo "ERROR: CloudCompare failed for $filename"
        exit $status
    fi
done

echo "Sorting and moving exported rasters..."

for f in "$INPUT_DIR"/*RASTER_Z*.tif; do

    [ -e "$f" ] || continue

    fname=$(basename "$f")
    
    base="${fname%%_RASTER_Z*}"

    echo "Moving: $fname -> ${base}.tif"
    mv "$f" "$OUTPUT_DIR/${base}.tif"

done

echo "------------------------------------------------"
echo "Finished: Heightmap Raster"
echo "Output: $OUTPUT_DIR"

