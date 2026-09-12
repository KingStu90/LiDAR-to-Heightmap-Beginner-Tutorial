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

find "$INPUT_DIR" -maxdepth 1 -name "*_COLOR.laz" -print0 | \
xargs -0 -I {} -P 4 bash -c '
    f="$1"
    filename=$(basename "$f")
    base="${filename%.laz}"

    echo "Rasterization $filename..."

    pdal pipeline "$2" \
        --stage.reader_las.filename="$f" \
        --stage.write_red.filename="$3/${base}_red.tif" \
        --stage.write_green.filename="$3/${base}_green.tif" \
        --stage.write_blue.filename="$3/${base}_blue.tif"

    echo "Finished: $filename"

' _ {} "$PIPELINE_JSON" "$OUTPUT_DIR"

echo "------------------------------------------------"
echo "Finished: Basemap RGB Raster - 4 Tile"
echo "Output: $OUTPUT_DIR"
