#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

RASTER_DIR="$PROJECT_ROOT/02_data/13b_trees_rasters"
OUTPUT_DIR="$PROJECT_ROOT/02_data/13b_trees_rasters"
VRT_FILE="$OUTPUT_DIR/trees.vrt"

if [ ! -d "$RASTER_DIR" ]; then
    echo "Error: Directory '$RASTER_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Building VRT from TIFFs in $RASTER_DIR..."

gdalbuildvrt \
    "$VRT_FILE" \
    "$RASTER_DIR"/*.tif

echo "Translating VRT to merged GeoTIFF..."

gdal_translate \
    -ot Float32 \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=3 \
    -co TILED=YES \
    -co BIGTIFF=IF_NEEDED \
    "$VRT_FILE" \
    "$OUTPUT_DIR/trees_MERGED.tif"

rm "$VRT_FILE"

echo "------------------------------------------------"
echo "Finished: Merging Rasters"
echo "Output: $OUTPUT_DIR"
