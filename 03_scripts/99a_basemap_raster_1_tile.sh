#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/04_colorize"
OUTPUT_DIR="$PROJECT_ROOT/02_data/11_basemap_raster"
RESOURCE_DIR="$PROJECT_ROOT/04_resources"

PIPELINE_JSON="$RESOURCE_DIR/99_pipeline_rasterize.json"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Color directory '$INPUT_DIR' does not exist."
    exit 1
fi

if [ ! -f "$PIPELINE_JSON" ]; then
    echo "Error: PDAL pipeline '$PIPELINE_JSON' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

for f in "$INPUT_DIR"/*.laz; do
    [ -e "$f" ] || {
        echo "No .laz files found in $INPUT_DIR."
        exit 1
    }

    filename=$(basename "$f")
    [[ "$filename" != *_COLOR.laz ]] && continue

    base=$(basename "$f" .laz)

    echo "Rasterizing: $filename"

    pdal pipeline "$PIPELINE_JSON" \
        --stage.reader_las.filename="$f" \
        --stage.write_red.filename="$OUTPUT_DIR/${base}_red.tif" \
        --stage.write_green.filename="$OUTPUT_DIR/${base}_green.tif" \
        --stage.write_blue.filename="$OUTPUT_DIR/${base}_blue.tif"

done

echo "------------------------------------------------"
echo "Finished: Basemap RGB Raster - 1 Tile"
echo "Output: $OUTPUT_DIR"
