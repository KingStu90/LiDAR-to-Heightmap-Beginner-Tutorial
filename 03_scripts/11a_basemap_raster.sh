#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/04_colorize"
OUTPUT_DIR="$PROJECT_ROOT/02_data/11_basemap_raster"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
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
            -GRID_STEP 0.5 \
            -VERT_DIR 2 \
            -PROJ AVG \
            -EMPTY_FILL KRIGING \
            -OUTPUT_RASTER_RGB

    status=$?

    if [ $status -ne 0 ]; then
        echo "ERROR: CloudCompare failed for $filename"
        exit $status
    fi

    # Move the exported raster before processing the next LAZ file
    for f in "$INPUT_DIR"/*RASTER_RGB*.tif; do

        [ -e "$f" ] || continue

        fname=$(basename "$f")
        
        raster_base="${fname%%_RASTER_RGB*}"

        echo "Moving: $fname -> ${raster_base}.tif"
        mv "$f" "$OUTPUT_DIR/${raster_base}.tif"

    done

done

echo "------------------------------------------------"
echo "Finished: Basemap Raster"
echo "Output: $OUTPUT_DIR"

