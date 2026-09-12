#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/01_download"
OUTPUT_DIR="$PROJECT_ROOT/02_data/01_download"

TARGET_SRS="EPSG:6424"

gdalbuildvrt \
    "$OUTPUT_DIR/mosaic.vrt" \
    "$INPUT_DIR"/*.tif

gdalwarp \
    -t_srs "$TARGET_SRS" \
    -r lanczos \
    -of VRT \
    "$OUTPUT_DIR/mosaic.vrt" \
    "$OUTPUT_DIR/reprojected.vrt"

gdal_translate \
    -co COMPRESS=LZW \
    -co BIGTIFF=IF_NEEDED \
    -co PREDICTOR=2 \
    -co TILED=YES \
    "$OUTPUT_DIR/reprojected.vrt" \
    "$OUTPUT_DIR/MERGED_REPROJECT.tif"

rm \
    "$OUTPUT_DIR/mosaic.vrt" \
    "$OUTPUT_DIR/reprojected.vrt"

echo "------------------------------------------------"
echo "Finished: Merging and Reprojecting Imagery"
echo "Output: $OUTPUT_DIR/MERGED_REPROJECT.tif"
