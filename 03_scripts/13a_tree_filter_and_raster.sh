#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/04_colorize"
RESOURCE_DIR="$PROJECT_ROOT/04_resources"

FILTER_OUTPUT_DIR="$PROJECT_ROOT/02_data/13a_trees_filter"
RASTER_OUTPUT_DIR="$PROJECT_ROOT/02_data/13b_trees_rasters"

FILTER_PIPELINE="$RESOURCE_DIR/13a_pipeline_trees_filter.json"
RASTER_PIPELINE="$RESOURCE_DIR/13b_pipeline_trees_raster.json"

mkdir -p "$FILTER_OUTPUT_DIR"
mkdir -p "$RASTER_OUTPUT_DIR"

for laz_file in "$INPUT_DIR"/*.laz; do
    [ -e "$laz_file" ] || {
        echo "No .laz files found in $INPUT_DIR."
        exit 1
    }

    base=$(basename "$laz_file" .laz)

    echo "========================================"
    echo "Processing: $base"
    echo "========================================"

    # Get original tile bounds
    bounds=$(pdal info --summary "$laz_file")

    read xmin xmax ymin ymax < <(
        echo "$bounds" | python -c '
import sys
import json

data = json.load(sys.stdin)
bbox = data["summary"]["bounds"]

print(bbox["minx"], bbox["maxx"], bbox["miny"], bbox["maxy"])
'
    )

    echo "Bounds:"
    echo "  X: $xmin → $xmax"
    echo "  Y: $ymin → $ymax"

    # Filter tree points
    pdal pipeline "$FILTER_PIPELINE" \
        --readers.las.filename="$laz_file" \
        --writers.las.filename="$FILTER_OUTPUT_DIR/${base}_TREES.laz"

    # Rasterize tree points using original tile extent
    pdal pipeline "$RASTER_PIPELINE" \
        --readers.las.filename="$FILTER_OUTPUT_DIR/${base}_TREES.laz" \
        --writers.gdal.filename="$RASTER_OUTPUT_DIR/${base}_TREES.tif" \
        --writers.gdal.bounds="([$xmin,$xmax],[$ymin,$ymax])"

    echo "Finished: $base"
done

echo "----------------------------------------"
echo "Finished: Tree Filtering and Rasterization"
echo "Tree LAS output: $FILTER_OUTPUT_DIR"
echo "Tree raster output: $RASTER_OUTPUT_DIR"
