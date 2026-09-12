#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

RASTER_DIR="$PROJECT_ROOT/02_data/11_basemap_raster"
OUTPUT_DIR="$PROJECT_ROOT/02_data/11_basemap_raster"

RED_VRT="$OUTPUT_DIR/rgb_red_mosaic.vrt"
GREEN_VRT="$OUTPUT_DIR/rgb_green_mosaic.vrt"
BLUE_VRT="$OUTPUT_DIR/rgb_blue_mosaic.vrt"
STACKED_VRT="$OUTPUT_DIR/rgb_stacked.vrt"

if [ ! -d "$RASTER_DIR" ]; then
    echo "Error: Directory '$RASTER_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Building VRTs from TIFFs in $RASTER_DIR..."

gdalbuildvrt \
    "$RED_VRT" \
    "$RASTER_DIR"/*_red.tif

gdalbuildvrt \
    "$GREEN_VRT" \
    "$RASTER_DIR"/*_green.tif

gdalbuildvrt \
    "$BLUE_VRT" \
    "$RASTER_DIR"/*_blue.tif

gdalbuildvrt \
    -separate \
    "$STACKED_VRT" \
    "$RED_VRT" \
    "$GREEN_VRT" \
    "$BLUE_VRT"

echo "Translating VRT to merged GeoTIFF..."

gdal_translate \
    -ot uint8 \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=2 \
    -co TILED=YES \
    -co PHOTOMETRIC=RGB \
    -co INTERLEAVE=PIXEL \
    -co BIGTIFF=IF_NEEDED \
    "$STACKED_VRT" \
    "$OUTPUT_DIR/basemap_MERGED.tif"

echo "Cleaning up temporary VRT files..."

rm "$RED_VRT" "$GREEN_VRT" "$BLUE_VRT" "$STACKED_VRT"

echo "------------------------------------------------"
echo "Finished: Merging Basemap RGB Layers"
echo "Output: $OUTPUT_DIR"
